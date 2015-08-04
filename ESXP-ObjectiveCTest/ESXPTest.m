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

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ESXPConstants.h"
#import "ESXPDocument.h"
#import "ESXPSAX2DOM.h"
#import "ESXPProcessorTest.h"

@interface ESXPTest : XCTestCase
// MARK: Properties
@property ESXPDocument      *doc;
@property NSError           *error;
@property ESXPProcessorTest *processor;
@end

@implementation ESXPTest
- (void)setUp
{
    [super setUp];
    
    // Read the XML.
    NSBundle *mainBundle = [NSBundle bundleForClass:[self class]];
    NSString *xmlFile    = [mainBundle pathForResource: @"test_huge" ofType: @"xml"];
    NSLog(@"BUNDLE ==> %@", xmlFile);
    
    NSData *data = [NSData dataWithContentsOfFile:xmlFile];
    if (!data)
        NSLog(@"Empty data file!");
    
    // Create the parser.
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    
    // Create an instance of our parser delegate and assign it to the parser
    ESXPSAX2DOM *parserDelegate = [[ESXPSAX2DOM alloc] init];
    [parser setDelegate:parserDelegate];
    
    // Invoke the parser and check the result
    [parser parse];
    self.error = [parser parserError];
    if (self.error) {
        NSString     *domain   = @"net.apkc.projects.ErrorDomain";
        NSString     *desc     = NSLocalizedString(@"Problema convirtiendo de SAX a DOM.", @"");
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
        
        NSLog(@"ERROR ==> %@", [[NSError errorWithDomain:domain
                                                    code:XMLPARSER_SAX2DOM_ERROR
                                                userInfo:userInfo] localizedDescription]);
    }
    
    self.doc = [parserDelegate getDOM];
    self.processor = [ESXPProcessorTest new];
    self.processor = [self.processor configure:self.doc rootNode:@"mediawiki"];
    
    NSLog(@"ELEMENT NODES COUNT ==> %u", [self.doc getElementNodeCount]);
}

- (void)tearDown
{
    // Teardown the parser here.
    
    [super tearDown];
}

- (void)testExample
{
    // Put validations here.
    
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample
{
    [self measureBlock:^{
        NSArray *pages = [self.processor getPages];
        if (kDEBUG) {
            for (id page in pages) {
                NSLog(@"%@", page);
            }
        }
    }];
}
@end
