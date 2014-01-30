//
//  WWPhotoDetailsAnimator.h
//  WayWay
//
//  Created by Jon Evans on 1/22/14.
//  Copyright (c) 2014 OMB Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWPhotoDetailsAnimator : NSObject <UINavigationControllerDelegate,UIViewControllerAnimatedTransitioning>

@property(nonatomic) BOOL reverse;
@property(nonatomic) CGPoint startPoint;
extern CGPoint photoCenterPos;

@end
