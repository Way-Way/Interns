//
//  WWSlider.h
//  WayWay
//
//  Created by Ryan DeVore on 7/01/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWSlider : UISlider
{
    CGRect _lastThumbBounds;
}

- (void) expandHeight:(CGFloat)newHeight;

@end