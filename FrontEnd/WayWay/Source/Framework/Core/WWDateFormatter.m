//
//  WWDateFormatter.m
//  WayWay
//
//  Created by Ryan DeVore on 6/24/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWDateFormatter.h"

static NSMutableDictionary* sharedDateFormatterCache = nil;

NSString * const kWWRFC3339DateFormatter = @"yyyy-MM-dd'T'HH:mm:ssZZ";

@implementation WWDateFormatter 

+ (NSDate*) dateFromRfc3339String:(NSString*)string
{
    return [self dateFromString:string withFormat:kWWRFC3339DateFormatter];
}

+ (NSDate*) dateFromString:(NSString*)string withFormat:(NSString*)format
{
    NSDateFormatter* df = [self getDateFormatter:format];
    return [df dateFromString:string];
}

+ (NSString*) dateToRfc3339String:(NSDate*)date
{
    return [self dateToString:date withFormat:kWWRFC3339DateFormatter];
}

+ (NSString*) dateToString:(NSDate*)date withFormat:(NSString*)format
{
    NSDateFormatter* df = [self getDateFormatter:format];
    return [df stringFromDate:date];
}

+ (NSMutableDictionary*) sharedCache
{
    if (sharedDateFormatterCache == nil)
    {
        sharedDateFormatterCache = [[NSMutableDictionary alloc] init];
    }
    
    return sharedDateFormatterCache;
}

+ (NSDateFormatter*) getDateFormatter:(NSString*)formatter
{
    NSMutableDictionary* cache = [self sharedCache];
    NSDateFormatter* df = [cache valueForKey:formatter];
    if (df == nil)
    {
        df = [[NSDateFormatter alloc] init];
        [df setDateFormat:formatter];
        [cache setValue:df forKey:formatter];
    }
    
    return df;
}

@end