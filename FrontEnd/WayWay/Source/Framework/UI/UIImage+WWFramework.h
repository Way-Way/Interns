//
//  UIImage+WWFramework.h
//  WayWay
//
//  Created by Ryan DeVore on 11/3/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WWFramework)

+ (UIImage*) wwSolidColorImage:(UIColor*)color;

+ (UIImage*) wwSolidColorImage:(UIColor*)color
                  cornerRadius:(CGFloat)cornerRadius
                   borderColor:(UIColor*)borderColor
                   borderWidth:(CGFloat)borderWidth;

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius
                       tintColor:(UIColor *)tintColor
           saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                       maskImage:(UIImage *)maskImage;

@end
