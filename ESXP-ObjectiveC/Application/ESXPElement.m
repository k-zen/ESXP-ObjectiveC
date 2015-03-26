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
#import "ESXPElement.h"

@implementation ESXPElement
+ (id<ESXPNode>)newBuild:(NSString *)name
{
    ESXPElement *instance = [[ESXPElement alloc] init];
    if (instance) {
        instance->parent     = nil;
        instance->name       = name;
        instance->value      = nil;
        instance->children   = [NSMutableArray new];
        instance->attributes = [NSMutableDictionary new];
    }
    else {
        return nil;
    }
    
    return instance;
}

- (id<ESXPNode>)appendChild:(id<ESXPNode>)newChild
{
    [self->children addObject:newChild];
    return newChild;
}

- (void)countElementNodes:(NSNumber **)counter
{
    for (id<ESXPNode> child in self->children) {
        if ([child getNodeType] == ELEMENT_NODE) {
            *counter = [NSNumber numberWithInt:[*counter intValue] + 1];
            
            if (kDEBUG) {
                NSLog(@"Counting Node ==> %@", [child getNodeName]);
                NSLog(@"Count ==> %i", [*counter intValue]);
            }
        }
    }
    
    // Drill down more.
    for (id<ESXPNode> child in self->children)
        [child countElementNodes:counter];
}

- (NSString *)description
{
    NSMutableString *str = [NSMutableString stringWithFormat:@"<ELEMENT> Name: %@ - Value: %@\n", self->name, self->value];
    NSEnumerator *enumerator = [self->attributes keyEnumerator];
    id key;
    while ((key = [enumerator nextObject]))
        [str appendFormat:@"\t<ATTRIBUTE> %@ : %@\n", (NSString *) key, [self->attributes objectForKey:key]];
    
    return str;
}

- (NSDictionary *)getAttributes { return self->attributes; }

- (NSString *)getBaseURI { return @""; }

- (NSMutableArray *)getChildNodes { return self->children; }

- (id<ESXPNode>)getFirstChild { return nil; }

- (id<ESXPNode>)getLastChild { return nil; }

- (NSString *)getLocalName { return @""; }

- (NSString *)getNamespaceURI { return @""; }

- (NSString *)getNodeName { return self->name; }

- (unsigned short)getNodeType { return ELEMENT_NODE; }

- (NSString *)getNodeValue { return self->value; }

- (id<ESXPNode>)getParentNode { return self->parent; }

- (BOOL)hasAttributes { return false; }

- (BOOL)hasChildNodes { return [self->children count] > 0; }

- (BOOL)isDefaultNamespace:(NSString *)namespaceURI { return false; }

- (BOOL)isEqualNode:(id<ESXPNode>)other { return [self isEqual:other]; }

- (BOOL)isSameNode:(id<ESXPNode>)other { return false; }

- (NSString *)lookupNamespaceURI:(NSString *)prefix { return @""; }

- (void)normalize
{
    short           firstTextNodePosition = -1;
    NSMutableArray  *objectsToRemove      = [NSMutableArray new];
    NSMutableString *normalizedText       = [NSMutableString new];
    
    for (id<ESXPNode> child in self->children) {
        if ([child getNodeType] == TEXT_NODE) {
            // Merge all TEXT_NODES together.
            // Save the position of the first TEXT_NODES in the array.
            if (firstTextNodePosition < 0)
                firstTextNodePosition = [self->children indexOfObject:child];
            // Now extract the text and mark the TEXT_NODE for removal.
            [normalizedText appendString:[child getNodeValue]];
            [objectsToRemove addObject:child];
            
            if (kDEBUG)
                NSLog(@"Normalizing Node ==> %@", [child getNodeName]);
        }
    }
    
    // Remove the objects.
    if ([objectsToRemove count] > 0)
        [self->children removeObjectsInArray:objectsToRemove];
    
    // Now finally add a new TEXT_NODE at first position found, but only if normalization has been done.
    if (firstTextNodePosition > -1) {
        ESXPText *mergedTextNode = [ESXPText newBuild:nil];
        [mergedTextNode setNodeValue:normalizedText];
        [self->children insertObject:mergedTextNode atIndex:firstTextNodePosition];
        if (kDEBUG)
            NSLog(@"\tMerged Node Result ==> %@", [mergedTextNode getNodeValue]);
    }
    
    // Drill down more.
    for (id<ESXPNode> child in self->children)
        [child normalize];
}

- (NSString *)printNode:(int)indent
{
    // Build indent
    NSMutableString *padding = [NSMutableString new];
    for (int i = 0; i < indent; ++i)
        [padding appendString:@"\t"];
    
    // Build string
    NSMutableString *string = [[self description] mutableCopy];
    for (id<ESXPNode> child in self->children)
        [string appendString:[NSString stringWithFormat:@"%@%@", padding, [child printNode:indent + 1]]];
    
    return string;
}

- (id<ESXPNode>)removeChild:(id<ESXPNode>)oldChild { return nil; }

- (id<ESXPNode>)replaceChild:(id<ESXPNode>)newChild oldChild:(id<ESXPNode>)oldChild { return nil; }

- (void)setAttribute:(NSString *)nodeName value:(NSString *)nodeValue { [self->attributes setObject:nodeValue forKey:nodeName]; }

- (void)setNodeValue:(NSString *)nodeValue { self->value = nodeValue; }
@end
