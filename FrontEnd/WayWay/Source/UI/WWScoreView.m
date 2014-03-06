//
//  WWScoreView.m
//  WayWay
//
//  Created by OMB Labs on 2/26/14.
//  Copyright (c) 2014 OMB Labs. All rights reserved.
//

#import "WWInclude.h"
#define WW_MAX_SCORE 10.0f
#define WW_SCORE_LOGO_LINE_WIDTH 2.0f

@implementation WWScoreView

/*- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}*/

-(void) awakeFromNib
{
    [super awakeFromNib];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    CGFloat score = [self.score floatValue];
    CGFloat startAngle = 3.0/2.0 * M_PI;
    CGFloat angle = 2*M_PI * score/WW_MAX_SCORE + startAngle;
    
    // Drawing code
    // Get the current graphics context
    // (ie. where the drawing should appear)
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the width of the line
    CGContextSetLineWidth(context, WW_SCORE_LOGO_LINE_WIDTH);
    
    
    CGContextAddArc(context,
                    rect.origin.x + rect.size.width/2.0,
                    rect.origin.y + rect.size.height/2.0,
                    (rect.size.height - WW_SCORE_LOGO_LINE_WIDTH)/2.0,
                    0,
                    2*M_PI,
                    NO);
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextDrawPath(context, kCGPathStroke);
    
    //Make the circle
    // 150 = x coordinate
    // 150 = y coordinate
    // 100 = radius of circle
    // 0   = starting angle
    // 2*M_PI = end angle
    // YES = draw clockwise
    CGContextBeginPath(context);
    CGContextAddArc(context,
                    rect.origin.x + rect.size.width/2.0,
                    rect.origin.y + rect.size.height/2.0,
                    (rect.size.height - WW_SCORE_LOGO_LINE_WIDTH)/2.0,
                    startAngle,
                    angle,
                    NO);
    
    // Set colour using RGB intensity values
    // 1.0 = 100% red, green or blue
    // the last value is alpha
    CGContextSetStrokeColorWithColor(context, WW_LEAD_COLOR.CGColor);
    CGContextDrawPath(context, kCGPathStroke);
    

    
    CGContextClosePath(context);
    
    
    // Note: If I wanted to only stroke the path, use:
    // CGContextDrawPath(context, kCGPathStroke);
    // or to only fill it, use:
    // CGContextDrawPath(context, kCGPathFill);
    
    //Fill/Stroke the path
    
    self.scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 ,0, rect.size.width, rect.size.height)];
    [self.scoreLabel setTextAlignment:NSTextAlignmentCenter];
    
    NSString* sb = [NSString stringWithFormat:@"%.1f", [self.score floatValue]];
    
    UIColor* scoreColor;
    if(self.isTrending)
        scoreColor = WW_LEAD_COLOR;
    else
        scoreColor = WW_GRAY_COLOR_9;

    self.scoreLabel.textColor = scoreColor;
    self.scoreLabel.font = WW_FONT_H5;
    
    [self.scoreLabel setText:sb];
    [self addSubview:self.scoreLabel];
}


@end
