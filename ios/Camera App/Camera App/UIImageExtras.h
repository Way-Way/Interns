//
//  UIImageExtras.h
//  Camera App
//
//  Created by mo_r on 29/11/13.
//  Copyright (c) 2013 mo_r. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (Extras)

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

@end