//
//  WWSlider.h
//  WayWay
//
//  Created by Ryan DeVore on 7/01/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWSlider.h"

@implementation WWSlider

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint p = [[touches anyObject] locationInView:self];
    
    if (CGRectContainsPoint(_lastThumbBounds, p))
    {
        [super touchesBegan:touches withEvent:event];
    }
    else
    {   
        CGFloat percent = p.x / self.bounds.size.width;
        self.value = self.minimumValue + ((self.maximumValue - self.minimumValue) * percent);
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value 
{    
    CGRect thumbRect = [super thumbRectForBounds:bounds trackRect:rect value:value];
    _lastThumbBounds = thumbRect;
    return thumbRect;
}

- (void) expandHeight:(CGFloat)newHeight
{
    CGPoint center = self.center;
    CGRect frame = self.frame;
    frame.size.height = newHeight;
    self.frame = frame;
    self.center = center;
}

#if _WS_RED_RECTS_
- (void) drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 1.0);
    CGContextSetRGBStrokeColor(ctx, 255, 0, 0, 1);
    CGContextStrokeRect(ctx, rect);
}
#endif

@end
