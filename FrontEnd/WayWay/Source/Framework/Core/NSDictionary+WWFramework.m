//
//  NSDictionary+WWFramework.m
//  WayWay
//
//  Created by Ryan DeVore on 6/7/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "NSDictionary+WWFramework.h"

@implementation NSDictionary (WWFramework)

- (id) wwNonNullValueForKey:(NSString*)key
{
    return [self wwNonNullValueForKey:key defaultValue:nil];
}

- (id) wwNonNullValueForKey:(NSString*)key defaultValue:(id)defaultVal
{
    id obj = [self valueForKey:key];
    if (obj != nil && ![obj isKindOfClass:[NSNull class]])
    {
        if ([obj isKindOfClass:[NSString class]])
        {
            // Hack to clean bad server data
            if ([@"null" isEqualToString:obj])
            {
                return defaultVal;
            }
        }
        
        return obj;
    }
    else
    {
        return defaultVal;
    }
}

@end
