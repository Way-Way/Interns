//
//  OverlayView.m
//  Camera App
//
//  Created by mo_r on 06/12/13.
//  Copyright (c) 2013 mo_r. All rights reserved.
//

#import "OverlayView.h"
#import "CameraAppViewController.h"

@implementation OverlayView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //clear the background color of the overlay
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        
        //load an image to show in the overlay
        UIImage *mask = [UIImage imageNamed:@"mask.png"];
        UIImageView *maskView = [[UIImageView alloc]
                                     initWithImage:mask];
        maskView.frame = CGRectMake(0, 20, 320, 460);
        [self addSubview:maskView];
        
        //add a simple button to the overview
        //with no functionality at the moment
//        UIButton *button = [UIButton
//                            buttonWithType:UIButtonTypeRoundedRect];
//        [button setTitle:@"Capture" forState:UIControlStateNormal];
//        button.frame = CGRectMake(130, 430, 60, 40);
//        [self addSubview:button];
    }
    return self;
}



@end
