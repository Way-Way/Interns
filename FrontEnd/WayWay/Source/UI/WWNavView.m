//
//  WWNavView.m
//  WayWay
//
//  Created by Ryan DeVore on 11/2/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@implementation WWNavView

- (UIEdgeInsets) alignmentRectInsets
{
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
    {
        return self.wwAlignmentRectInsets;
    }
    else
    {
        return UIEdgeInsetsZero;
    }
}

@end