//
//  WWHashtagButton.m
//  WayWay
//
//  Created by OMB Labs on 2/4/14.
//  Copyright (c) 2014 OMB Labs. All rights reserved.
//

#import "WWInclude.h"

@implementation WWHashtagButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.layer.cornerRadius = 2;
        self.layer.borderWidth = 1;
        self.layer.borderColor = WW_GRAY_BORDER.CGColor;
        
        self.titleLabel.font = [UIFont fontWithName:WW_DEFAULT_FONT_NAME size:18];
        [self.titleLabel setTextColor:[UIColor blackColor]];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return self;
}


-(void) setHashtag:(NSString*)hashtag withColor:(UIColor*)color
{
    self.hashtag = hashtag;
    NSString* hashtagText = [NSString stringWithFormat:@"#%@", hashtag];
    [self setTitle:hashtagText forState:UIControlStateNormal];
    [self setTitleColor:color forState:UIControlStateNormal];
    self.highlighted = YES;
    
    CGRect frame;
    CGSize textSize = [hashtagText sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    
    frame = self.frame;
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, textSize.width + 8.0f, textSize.height + 6.0f);
    
    frame = self.titleLabel.frame;
    self.titleLabel.frame = CGRectMake(4.0f, 3.0f, textSize.width, textSize.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
