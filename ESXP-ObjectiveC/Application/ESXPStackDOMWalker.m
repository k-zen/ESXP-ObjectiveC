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

#import "ESXPStackDOMWalker.h"

@implementation ESXPStackDOMWalker
// MARK: Builders
+ (ESXPStackDOMWalker *)newBuild
{
    ESXPStackDOMWalker *instance = [[ESXPStackDOMWalker alloc] init];
    if (instance)
        return instance;
    else
        return nil;
}

// MARK: Methods
- (ESXPStackDOMWalker *)configure:(ESXPElement *)rootNode nodesToProcess:(unsigned short)ntp
{
    if (rootNode == nil) {
        return self;
    }
    
    self->nodes = [[AKStack alloc] init];
    [self->nodes push:rootNode];
    self->nodesToProcess = ntp;
    
    return self;
}

- (id<ESXPNode>)nextNode
{
    if (![self hasNext])
        return nil;
    
    self->currentNode = [self->nodes pop];
    self->currentChildren = [self->currentNode getChildNodes];
    
    int childLen = (self->currentChildren != nil) ? (int) [self->currentChildren count] : 0;
    for (int i = childLen - 1; i >= 0; i--) {
        switch (self->nodesToProcess) {
            case ELEMENT_NODE:
                if ([[self->currentChildren objectAtIndex:i] getNodeType] == ELEMENT_NODE)
                    [self->nodes push:[self->currentChildren objectAtIndex:i]];
                break;
            case TEXT_NODE:
                if ([[self->currentChildren objectAtIndex:i] getNodeType] == TEXT_NODE)
                    [self->nodes push:[self->currentChildren objectAtIndex:i]];
                break;
        }
    }
    
    return self->currentNode;
}

- (void)skipChildren
{
    int childLen = (self->currentChildren != nil) ? (int) [self->currentChildren count] : 0;
    for (int i = 0; i < childLen; i++) {
        id<ESXPNode> child = [self->nodes peek];
        if ([child isEqualNode:[self->currentChildren objectAtIndex:i]])
            [self->nodes pop];
    }
}

- (BOOL)hasNext { return [self->nodes size] > 0; }
@end
