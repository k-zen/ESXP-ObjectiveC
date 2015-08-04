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

#import "ESXPWikiPage.h"

@implementation ESXPWikiPage
// MARK: NSObject Overriding
- (NSString *)description
{
    NSMutableString *b = [NSMutableString new];
    [b appendString:[NSString stringWithFormat:@"[Title]:%@", self._title]];
    [b appendString:[NSString stringWithFormat:@"\n\t[NS]:%@", self._ns]];
    [b appendString:[NSString stringWithFormat:@"\n\t[Id]:%@", self._id]];
    [b appendString:[NSString stringWithFormat:@"\n\t[Rev Id]:%@", self._revId]];
    [b appendString:[NSString stringWithFormat:@"\n\t[Rev Parent Id]:%@", self._revParentId]];
    [b appendString:[NSString stringWithFormat:@"\n\t[Rev Timestamp]:%@", self._revTimestamp]];
    [b appendString:[NSString stringWithFormat:@"\n\t[Rev Contributor Username]:%@", self._revContributorUsername]];
    [b appendString:[NSString stringWithFormat:@"\n\t[Rev Contributor Id]:%@", self._revContributorId]];
    [b appendString:[NSString stringWithFormat:@"\n\t[Rev Minor]:%@", self._revMinor]];
    [b appendString:[NSString stringWithFormat:@"\n\t[Rev Comment]:%@", self._revComment]];
    [b appendString:[NSString stringWithFormat:@"\n\t[Rev Text]:%@", self._revText]];
    [b appendString:[NSString stringWithFormat:@"\n\t[Rev Text Id]:%@", self._revTextId]];
    [b appendString:[NSString stringWithFormat:@"\n\t[Rev Text Bytes]:%@", self._revTextBytes]];
    [b appendString:[NSString stringWithFormat:@"\n\t[Rev SHA1]:%@", self._revSHA1]];
    [b appendString:[NSString stringWithFormat:@"\n\t[Rev Model]:%@", self._revModel]];
    [b appendString:[NSString stringWithFormat:@"\n\t[Rev Format]:%@", self._revFormat]];
    
    return [NSString stringWithString:b];
}
@end
