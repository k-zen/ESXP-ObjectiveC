#import <Foundation/Foundation.h>

@interface ESXPConstants : NSObject
@end

#pragma ****** Options ******
typedef NS_OPTIONS(int, ErrorCodes)
{
    // XML PARSER
    XMLPARSER_SAX2DOM_ERROR = -90, // Called when there was an error converting from SAX to DOM.
    XMLPARSER_NIL_DOCUMENT  = -91, // Called when trying to parse an empty document.
};

static BOOL const kDEBUG = NO; // If mode debug is on/off.
