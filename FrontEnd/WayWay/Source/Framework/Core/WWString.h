//
//  WWString.h
//  WayWay - String Utilities
//
//  Created by Ryan DeVore on 7/24/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (WWStringTwiddling)

- (NSString*) wwToHexString;

@end

@interface NSString (WWFramework)

- (NSString*) wwFormatAsMentionsSummary;

@end