/*
 * Copyright (c) 2014, Andreas P. Koenzen <akc at apkc.net>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * * Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 * * Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#import "ESXPProcessorTest.h"

@implementation ESXPProcessorTest
- (id)init
{
    self = [super init];
    if (self) {
        _processor = [ESXPProcessor new];
    }
    return self;
}

- (ESXPProcessorTest *)configure:(ESXPDocument *)doc rootNode:(NSString *)rootNode
{
    @try {
        self.walker = [[ESXPStackDOMWalker newBuild] configure:(ESXPElement *)[self.processor searchNode:doc rootNodeName:rootNode tagName:@"mediawiki"] nodesToProcess:ELEMENT_NODE];
    }
    @catch (NSException *exception) {
        NSString     *domain   = @"net.apkc.projects.ErrorDomain";
        NSString     *desc     = NSLocalizedString(exception.reason, @"");
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
        NSError      *error    = [NSError errorWithDomain:domain code:XMLPARSER_NIL_DOCUMENT userInfo:userInfo];
        
        NSLog(@"ERROR ==> %@", [error localizedDescription]);
    }
    @finally {
        return self;
    }
}

- (NSArray *)getPages
{
    @try {
        NSMutableArray *pages = [NSMutableArray new];
        while ([self.walker hasNext]) {
            id<ESXPNode> node = [self.walker nextNode];
            if ([node getNodeType] == ELEMENT_NODE) {
                if ([[node getNodeName] isEqualToString:@"page"]) {
                    ESXPWikiPage       *page = [ESXPWikiPage new];
                    ESXPStackDOMWalker *subWalker = [[ESXPStackDOMWalker newBuild] configure:(ESXPElement *)node nodesToProcess:ELEMENT_NODE];
                    while ([subWalker hasNext]) {
                        id<ESXPNode> subNode = [subWalker nextNode];
                        if ([[subNode getNodeName] isEqualToString:@"title"]) {
                            page._title = [self.processor getNodeValue:subNode strict:NO];
                        }
                        else if ([[subNode getNodeName] isEqualToString:@"ns"]) {
                            page._ns = [self.processor getNodeValue:subNode strict:NO];
                        }
                        else if ([[subNode getNodeName] isEqualToString:@"id"]) {
                            if ([[[subNode getParentNode] getNodeName] isEqualToString:@"page"]) {
                                page._id = [self.processor getNodeValue:subNode strict:NO];
                            }
                            else if ([[[subNode getParentNode] getNodeName] isEqualToString:@"revision"]) {
                                page._revId = [self.processor getNodeValue:subNode strict:NO];
                            }
                            else if ([[[subNode getParentNode] getNodeName] isEqualToString:@"contributor"]) {
                                page._revContributorId = [self.processor getNodeValue:subNode strict:NO];
                            }
                        }
                        else if ([[subNode getNodeName] isEqualToString:@"parentid"]) {
                            page._revParentId = [self.processor getNodeValue:subNode strict:NO];
                        }
                        else if ([[subNode getNodeName] isEqualToString:@"timestamp"]) {
                            page._revTimestamp = [self.processor getNodeValue:subNode strict:NO];
                        }
                        else if ([[subNode getNodeName] isEqualToString:@"username"]) {
                            page._revContributorUsername = [self.processor getNodeValue:subNode strict:NO];
                        }
                        else if ([[subNode getNodeName] isEqualToString:@"minor"]) {
                            page._revMinor = [self.processor getNodeValue:subNode strict:NO];
                        }
                        else if ([[subNode getNodeName] isEqualToString:@"comment"]) {
                            page._revComment = [self.processor getNodeValue:subNode strict:NO];
                        }
                        else if ([[subNode getNodeName] isEqualToString:@"text"]) {
                            page._revTextId    = [self.processor getNodeAttributeValue:subNode attributeName:@"id" strict:NO];
                            page._revTextBytes = [self.processor getNodeAttributeValue:subNode attributeName:@"bytes" strict:NO];
                            page._revText      = [self.processor getNodeValue:subNode strict:NO];
                        }
                        else if ([[subNode getNodeName] isEqualToString:@"sha1"]) {
                            page._revSHA1 = [self.processor getNodeValue:subNode strict:NO];
                        }
                        else if ([[subNode getNodeName] isEqualToString:@"model"]) {
                            page._revModel = [self.processor getNodeValue:subNode strict:NO];
                        }
                        else if ([[subNode getNodeName] isEqualToString:@"format"]) {
                            page._revFormat = [self.processor getNodeValue:subNode strict:NO];
                        }
                    }
                    
                    [pages addObject:page];
                    page = [ESXPWikiPage new];
                }
            }
        }
        
        return pages;
    }
    @catch (NSException *exception) {
        NSString     *domain   = @"net.apkc.projects.ErrorDomain";
        NSString     *desc     = NSLocalizedString(exception.reason, @"");
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
        NSError      *error    = [NSError errorWithDomain:domain code:XMLPARSER_NIL_DOCUMENT userInfo:userInfo];
        
        NSLog(@"ERROR ==> %@", [error localizedDescription]);
        
        return [NSMutableArray new];
    }
}
@end
