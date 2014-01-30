//
//  UIView+WWNibLoading.h
//  WayWay
//
//  Created by Ryan DeVore on 7/2/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WWNibLoading)

+ (id) wwLoadFromNib;
+ (id) wwLoadFromNib:(NSString*)nibName;

+ (CGSize) wwSizeFromNib;
+ (CGSize) wwSizeFromNib:(NSString*)nibName;

+ (CGFloat) wwHeightFromNib;
+ (CGFloat) wwHeightFromNib:(NSString*)nibName;

+ (id) wwLoadAndReplaceView:(UIView*)subView;

@end
