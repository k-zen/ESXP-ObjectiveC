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

#import "ESXPProcessor.h"

@implementation ESXPProcessor
+ (ESXPProcessor *)newBuild
{
    ESXPProcessor *instance = [[ESXPProcessor alloc] init];
    if (instance)
        return instance;
    else
        return nil;
}

- (NSString *)searchTagValue:(ESXPDocument *)doc rootNodeName:(NSString *)rootNodeName tagName:(NSString *)tagName strict:(BOOL)strict
{
    ESXPStackDOMWalker *walker = [[ESXPStackDOMWalker newBuild] configure:[doc getRootNode] nodesToProcess:ELEMENT_NODE];
    while ([walker hasNext]) {
        id<ESXPNode> node = [walker nextNode];
        if ([[node getNodeName] isEqualToString:tagName])
            return [self getNodeValue:node strict:strict];
    }
    
    if (strict)
        @throw [NSException exceptionWithName:@"TagNotFoundException"
                                       reason:[NSString stringWithFormat:@"The tag \"%@\" was not found in the XML.", tagName]
                                     userInfo:nil];
    else
        return @"";
}

- (NSString *)searchTagAttributeValue:(ESXPDocument *)doc rootNodeName:(NSString *)rootNodeName tagName:(NSString *)tagName attributeName:(NSString *)attributeName strict:(BOOL)strict
{
    ESXPStackDOMWalker *walker = [[ESXPStackDOMWalker newBuild] configure:[doc getRootNode] nodesToProcess:ELEMENT_NODE];
    while ([walker hasNext]) {
        id<ESXPNode> node = [walker nextNode];
        if ([node getNodeType] == ELEMENT_NODE) {
            if ([[node getNodeName] isEqualToString:tagName]) {
                NSDictionary *attributes = [node getAttributes];
                if (attributes == nil) {
                    if (strict)
                        @throw [NSException exceptionWithName:@"AttributeNotFoundException"
                                                       reason:[NSString stringWithFormat:@"The tag \"%@\" does not contain attributes.", tagName]
                                                     userInfo:nil];
                    else
                        return @"";
                }
                else {
                    NSString *attribute = [attributes objectForKey:attributeName];
                    if (attribute == nil) {
                        if (strict)
                            @throw [NSException exceptionWithName:@"AttributeNotFoundException"
                                                           reason:[NSString stringWithFormat:@"The attribute \"%@\" does not exists.", attributeName]
                                                         userInfo:nil];
                        else
                            return @"";
                    }
                    else {
                        return attribute;
                    }
                }
            }
        }
    }
    
    if (strict)
        @throw [NSException exceptionWithName:@"TagNotFoundException"
                                       reason:[NSString stringWithFormat:@"The tag \"%@\" was not found in the XML.", tagName]
                                     userInfo:nil];
    else
        return @"";
}

- (NSString *)getNodeAttributeValue:(id<ESXPNode>)node attributeName:(NSString *)attributeName strict:(BOOL)strict
{
    if ([node getNodeType] != ELEMENT_NODE) {
        @throw [NSException exceptionWithName:@"InvalidNodeException"
                                       reason:@"The node is not an element node."
                                     userInfo:nil];
    }
    
    NSDictionary *attributes = [node getAttributes];
    if (attributes == nil) {
        if (strict)
            @throw [NSException exceptionWithName:@"AttributeNotFoundException"
                                           reason:@"The node does not contain attributes."
                                         userInfo:nil];
        else
            return @"";
    }
    else {
        NSString *attribute = [attributes objectForKey:attributeName];
        if (attribute == nil) {
            if (strict)
                @throw [NSException exceptionWithName:@"AttributeNotFoundException"
                                               reason:@"The attribute does not exists."
                                             userInfo:nil];
            else
                return @"";
        }
        else {
            return attribute;
        }
    }
}

- (NSString *)getNodeValue:(id<ESXPNode>)node strict:(BOOL)strict
{
    ESXPStackDOMWalker *walker = [[ESXPStackDOMWalker newBuild] configure:(ESXPElement *)node nodesToProcess:TEXT_NODE];
    while ([walker hasNext]) {
        id<ESXPNode> node = [walker nextNode];
        if ([node getNodeType] == COMMENT_NODE)
            [walker skipChildren];
        
        if ([node getNodeType] == TEXT_NODE) {
            NSString *text = [node getNodeValue];
            if ([text length] > 0)
                return text;
        }
    }
    
    if (strict)
        @throw [NSException exceptionWithName:@"TextNotFoundException"
                                       reason:@"This node contains no text."
                                     userInfo:nil];
    else
        return @"";
}

- (id<ESXPNode>)retrieveSubNode:(NSString *)name node:(id<ESXPNode>)node
{
    if ([node getNodeType] != ELEMENT_NODE || ![node hasChildNodes])
        return nil;
    
    NSMutableArray *children = [node getChildNodes];
    for (id<ESXPNode> n in children) {
        if ([n getNodeType] == ELEMENT_NODE) {
            if ([[n getNodeName] isEqualToString:name]) {
                return n;
            }
        }
    }
    
    @throw [NSException exceptionWithName:@"NodeNotFoundException"
                                   reason:[NSString stringWithFormat:@"A sub node named \"%@\" was not found.", name]
                                 userInfo:nil];
}

- (id<ESXPNode>)searchNode:(ESXPDocument *)doc rootNodeName:(NSString *)rootNodeName tagName:(NSString *)tagName
{
    ESXPStackDOMWalker *walker = [[ESXPStackDOMWalker newBuild] configure:[doc getRootNode] nodesToProcess:ELEMENT_NODE];
    while ([walker hasNext]) {
        id<ESXPNode> node = [walker nextNode];
        if ([[node getNodeName] isEqualToString:tagName])
            return node;
    }
    
    @throw [NSException exceptionWithName:@"NodeNotFoundException"
                                   reason:[NSString stringWithFormat:@"The node \"%@\" was not found in the XML.", tagName]
                                 userInfo:nil];
}
@end
