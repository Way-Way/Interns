//
//  WWTextField.m
//  WayWay
//
//  Created by Ryan DeVore on 7/24/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWTextField.h"

@implementation WWTextField

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds
{
    return UIEdgeInsetsInsetRect(bounds, self.contentInsets);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return UIEdgeInsetsInsetRect(bounds, self.contentInsets);
}

@end
