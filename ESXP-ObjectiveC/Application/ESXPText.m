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

#import "ESXPText.h"

@implementation ESXPText
+ (id<ESXPNode>)newBuild:(NSString *)name
{
    ESXPText *instance = [[ESXPText alloc] init];
    if (instance) {
        instance->parent = nil;
        instance->name   = @"#text";
        instance->value  = @"";
    }
    
    return instance;
}

- (id<ESXPNode>)appendChild:(id<ESXPNode>)newChild { return nil; }

- (NSString *)description { return [NSString stringWithFormat:@"Name: %@ - Value: %@", self->name, self->value]; }

- (NSDictionary *)getAttributes { return nil; }

- (NSString *)getBaseURI { return @""; }

- (NSMutableArray *)getChildNodes { return nil; }

- (id<ESXPNode>)getFirstChild { return nil; }

- (id<ESXPNode>)getLastChild { return nil; }

- (NSString *)getLocalName { return @""; }

- (NSString *)getNamespaceURI { return @""; }

- (NSString *)getNodeName { return self->name; }

- (unsigned short)getNodeType { return TEXT_NODE; }

- (NSString *)getNodeValue { return self->value; }

- (id<ESXPNode>)getParentNode { return self->parent; }

- (BOOL)hasAttributes { return false; }

- (BOOL)hasChildNodes { return false; }

- (BOOL)isDefaultNamespace:(NSString *)namespaceURI { return false; }

- (BOOL)isEqualNode:(id<ESXPNode>)other { return [self isEqual:other]; }

- (BOOL)isSameNode:(id<ESXPNode>)other { return false; }

- (NSString *)lookupNamespaceURI:(NSString *)prefix { return @""; }

- (void)normalize
{
    // TODO
}

- (NSString *)printNode:(int)indent
{
    // Build indent
    NSMutableString *padding = [NSMutableString new];
    for (int i = 0; i < indent; ++i)
        [padding appendString:@"\t"];
    
    return [[self description] mutableCopy];
}

- (id<ESXPNode>)removeChild:(id<ESXPNode>)oldChild { return nil; }

- (id<ESXPNode>)replaceChild:(id<ESXPNode>)newChild oldChild:(id<ESXPNode>)oldChild { return nil; }

- (void)setNodeValue:(NSString *)nodeValue { self->value = nodeValue; }
@end