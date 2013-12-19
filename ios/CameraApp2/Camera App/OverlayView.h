//
//  OverlayView.h
//  Camera App
//
//  Created by mo_r on 06/12/13.
//  Copyright (c) 2013 mo_r. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OverlayView : UIView

@property (weak, nonatomic) UIButton *captureButton;
@property (weak, nonatomic) UIButton *cameraRevButton;

- (void)cameraRevWithTarget:(id)target action:(SEL)selector controlEvents:(UIControlEvents)controlEvents;
- (void)captureWithTarget:(id)target action:(SEL)selector controlEvents:(UIControlEvents)controlEvents;

@end
