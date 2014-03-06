//
//  WWHashTagSummaryHeaderView.m
//  WayWay
//
//  Created by Ryan DeVore on 10/18/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWHashTagSummaryHeaderView ()

@property (nonatomic, strong) CALayer* topBorder;
@property (nonatomic, strong) CALayer* bottomBlackBorder;
@property (nonatomic, strong) CALayer* bottomGreyIndentedBorder;

@end

@implementation WWHashTagSummaryHeaderView

- (void) awakeFromNib
{
    self.hashTagLabel.font = WW_FONT_H1;
    self.countLabel.font = WW_FONT_H5;
    [self.countLabel setTextColor:WW_GRAY_COLOR_7];
    
    CALayer* layer = [CALayer layer];
    layer.borderColor = [WW_GRAY_COLOR_4 CGColor];
    layer.borderWidth = 0.5f;
    self.bottomGreyIndentedBorder = layer;
    [self.layer addSublayer:layer];
    layer.hidden = YES;
    
    layer = [CALayer layer];
    layer.borderColor = [[UIColor blackColor] CGColor];
    layer.borderWidth = 0.5f;
    self.topBorder = layer;
    [self.layer addSublayer:layer];
    layer.hidden = YES;
    
    layer = [CALayer layer];
    layer.borderColor = [[UIColor blackColor] CGColor];
    layer.borderWidth = 0.5f;
    self.bottomBlackBorder = layer;
    [self.layer addSublayer:layer];
    layer.hidden = YES;
}

- (void) update:(WWHashtag*)hashTag prev:(id)prev next:(id)next
{
    self.hashTagLabel.text = [NSString stringWithFormat:@"#%@", hashTag.name];
    self.countLabel.text = [NSString stringWithFormat:@"%@", [[hashTag.count stringValue] wwFormatAsMentionsSummary]];
    
    self.topBorder.hidden = YES;
    self.bottomBlackBorder.hidden = YES;
    self.bottomGreyIndentedBorder.hidden = NO;
    
    if (prev)
    {
        if ([prev isKindOfClass:[WWPhoto class]])
        {
            self.topBorder.hidden = NO;
        }
    }
    
    if (next && [next isKindOfClass:[WWPhoto class]])
    {
        self.bottomBlackBorder.hidden = NO;
        self.bottomGreyIndentedBorder.hidden = YES;
    }
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.topBorder.frame = CGRectMake(0, 0, self.bounds.size.width, self.topBorder.borderWidth);
    self.bottomBlackBorder.frame = CGRectMake(0, self.bounds.size.height - self.bottomBlackBorder.borderWidth, self.bounds.size.width, self.bottomBlackBorder.borderWidth);
    
    CGFloat leftIndent = 15;
    self.bottomGreyIndentedBorder.frame = CGRectMake(leftIndent, self.bounds.size.height - self.bottomGreyIndentedBorder.borderWidth, self.bounds.size.width - leftIndent, self.bottomGreyIndentedBorder.borderWidth);
}

@end
