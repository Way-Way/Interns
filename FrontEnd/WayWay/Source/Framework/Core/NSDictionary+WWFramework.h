//
//  NSDictionary+WWFramework.h
//  WayWay
//
//  Created by Ryan DeVore on 6/7/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (WWFramework)

- (id) wwNonNullValueForKey:(NSString*)key;
- (id) wwNonNullValueForKey:(NSString*)key defaultValue:(id)defaultVal;

@end
