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

#import "ESXPConstants.h"
#import "ESXPDocument.h"

@implementation ESXPDocument
+ (ESXPDocument *)newBuild:(NSString *)name
{
    ESXPDocument *instance = [[ESXPDocument alloc] init];
    if (instance)
        instance->root = [ESXPElement newBuild:name];
    else
        return nil;
    
    return instance;
}

+ (NSString *)printDocument:(ESXPDocument *)document
{
    ESXPElement *root = (ESXPElement *) [document getRootNode];
    
    // Build string
    NSMutableString *string   = [[NSString stringWithFormat:@"\n%@", [root description]] mutableCopy];
    NSMutableArray  *nodeList = [root getChildNodes];
    for (id<ESXPNode> child in nodeList)
        [string appendString:[NSString stringWithFormat:@"%@%@", [NSMutableString new], [child printNode:1]]];
    
    return string;
}

- (NSString *)description { return [NSString stringWithFormat:@"Name: DOMDocument"]; }

- (ESXPElement *)getRootNode { return self->root; }

- (int)getElementNodeCount
{
    NSNumber       *counter  = [NSNumber numberWithInt:0];
    NSMutableArray *nodeList = [root getChildNodes];
    
    for (id<ESXPNode> child in nodeList) {
        if ([child getNodeType] == ELEMENT_NODE) {
            counter = [NSNumber numberWithInt:[counter intValue] + 1];
            
            if (kDEBUG) {
                NSLog(@"Counting Node ==> %@", [child getNodeName]);
                NSLog(@"Count ==> %i", [counter intValue]);
            }
        }
    }
    
    for (id<ESXPNode> child in nodeList)
        [child countElementNodes:&counter];
    
    return [counter intValue];
}
@end