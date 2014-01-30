//
//  UIView+WWStyling.h
//  WayWay
//
//  Created by Ryan DeVore on 11/2/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface UIView (WWStyling)

- (void) wwStyleWhiteButtonBorder;
- (void) wwStyleLightBlueBorder;
- (void) wwStyleLightGrayButtonBorder;
- (void) wwStyleLightOrangeBorder;

- (void) wwStyleWithRoundedCorners;
- (void) wwStyleLightGreyTopAndBottomBorders;
- (void) wwStyleNavBottomSeparatorBorder;
- (void) wwStyleWithTopAndBottomBorder:(UIColor*)color width:(CGFloat)borderWidth;

+ (UIImage *) wwBlurredImageWithView:(UIView *)view;


// DEBUG
- (void) printSubviews:(int)indent recursive:(BOOL)recursive;

@end
