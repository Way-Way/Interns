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
        
        self.captureButton = [UIButton
                              buttonWithType:UIButtonTypeCustom];
        [self.captureButton setImage:[UIImage imageNamed:@"captureButton.png"] forState:UIControlStateNormal];
        self.captureButton.frame = CGRectMake(125, 390, 70, 70);
        self.captureButton.layer.cornerRadius = 35; //half of the with
        self.cameraRevButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cameraRevButton setImage:[UIImage imageNamed:@"reverseCamera.png"] forState:UIControlStateNormal];
        self.cameraRevButton.frame = CGRectMake(225, 20, 50, 35);

        [self addSubview:self.cameraRevButton];
        [self addSubview:self.captureButton];
        [self addSubview:maskView];
    }
    return self;
}

- (void)cameraRevWithTarget:(id)target action:(SEL)selector controlEvents:(UIControlEvents)controlEvents
{
    [self.cameraRevButton addTarget:target action:selector forControlEvents:controlEvents];
}

- (void)captureWithTarget:(id)target action:(SEL)selector controlEvents:(UIControlEvents)controlEvents
{
    [self.captureButton addTarget:target action:selector forControlEvents:controlEvents];
}

@end
