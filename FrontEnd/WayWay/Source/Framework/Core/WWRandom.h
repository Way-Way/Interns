//
//  WWRandom.h
//  WayWay
//
//  Created by Ryan DeVore on 11/7/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWRandom : NSObject

+ (UInt32) randomUInt32;
+ (UInt32) randomUInt32BetweenLow:(UInt32)low High:(UInt32)high;

@end

@interface NSArray (WWRandom)

- (NSUInteger) randomIndex;
- (id) randomElement;

@end