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
#import "ESXPSAX2DOM.h"

@implementation ESXPSAX2DOM
- (ESXPSAX2DOM *)init
{
    self = [super init];
    if (self) {
        self.document = [ESXPDocument newBuild:@"_root"];    // Create a new DOM document.
        self.stack    = [[AKStack alloc] initWithSize:1000]; // Initialize the stack with just 1000 nodes.
    }
    
    return self;
}

- (void) parserDidStartDocument:(NSXMLParser *)parser { [self.stack push:[self.document getRootNode]]; }

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if (kDEBUG)
        NSLog(@"didStartElement --> %@", elementName);
    
    ESXPElement *tmp = [ESXPElement newBuild:elementName];
    
    // Add the attributes to the node.
    NSEnumerator *enumerator = [attributeDict keyEnumerator];
    id key;
    while ((key = [enumerator nextObject]))
        [tmp setAttribute:key value:[attributeDict objectForKey:key]];
    
    // Append the new node into the stack.
    ESXPElement *last = (ESXPElement *)[self.stack peek];
    [last appendChild:tmp];
    [self.stack push:tmp];
    self.lastSibling = nil;
}

-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (kDEBUG)
        NSLog(@"foundCharacters --> %@", string);
    
    ESXPElement *last = (ESXPElement *)[self.stack peek];
    ESXPText    *text = [ESXPText newBuild:nil];
    [text setNodeValue:string];
    
    self.lastSibling = (ESXPText *) [last appendChild:text];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (kDEBUG)
        NSLog(@"didEndElement   --> %@", elementName);
    
    [self.stack pop];
    self.lastSibling = nil;
}

- (void) parserDidEndDocument:(NSXMLParser *)parser { [self.stack pop]; }

-(ESXPDocument *)getDOM { return self.document; }
@end
