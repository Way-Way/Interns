//
//  WWDateFormatter.h
//  WayWay
//
//  Created by Ryan DeVore on 6/24/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kWWRFC3339DateFormatter;

@interface WWDateFormatter : NSObject

+ (NSDate*) dateFromRfc3339String:(NSString*)string;
+ (NSDate*) dateFromString:(NSString*)string withFormat:(NSString*)format;

+ (NSString*) dateToRfc3339String:(NSDate*)date;
+ (NSString*) dateToString:(NSDate*)date withFormat:(NSString*)format;
   
@end