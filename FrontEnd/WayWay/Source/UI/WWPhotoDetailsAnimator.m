//
//  WWPhotoDetailsAnimator.m
//  WayWay
//
//  Created by Jon Evans on 1/22/14.
//  Copyright (c) 2014 OMB Labs. All rights reserved.
//

#import "WWPhotoDetailsAnimator.h"

@implementation WWPhotoDetailsAnimator

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.reverse = YES;
    return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    
    if (self.reverse) {
        [container insertSubview:toViewController.view belowSubview:fromViewController.view];
    }
    else {
        toViewController.view.center = self.startPoint;
        toViewController.view.transform = CGAffineTransformMakeScale(0, 0);
        [container addSubview:toViewController.view];
    }
    
    [UIView animateKeyframesWithDuration:0.5f delay:0 options:0 animations:^{
        if (self.reverse) {
            fromViewController.view.transform = CGAffineTransformMakeScale(0, 0);
            fromViewController.view.center = self.startPoint;
        } else {
            toViewController.view.transform = CGAffineTransformIdentity;
            toViewController.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
        }
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
        toViewController.navigationController.delegate=nil;
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.15f;
}
@end
