//
//  WWPlaceDetailsHeaderInfoCell.m
//  WayWay
//
//  Created by Ryan DeVore on 10/27/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@implementation WWPlaceDetailsHeaderInfoCell

- (void) awakeFromNib
{
    [self.categoriesLabel wwStyleWithFontOfSize:WW_SUB_LABEL_FONT_SIZE];
    self.categoriesLabel.textColor = WW_LIGHT_GRAY_FONT_COLOR;
    
}

- (void) update:(WWPlace*)place
{
    self.categoriesLabel.text = [place combinedCategories];
    self.trendingIcon.hidden = !place.isTrending.boolValue;
    
    //[self refreshScoreLabel];
    [self refreshInfoLabel:place];
    
    [self.infoLabel wwResizeWidth];
    
    CGRect f = self.trendingIcon.frame;
    f.origin.x = self.infoLabel.frame.origin.x + self.infoLabel.frame.size.width;
    f.origin.y = self.infoLabel.frame.origin.y + (self.infoLabel.frame.size.height / 2) - (f.size.height / 2);
    self.trendingIcon.frame = f;
}


- (void) refreshInfoLabel:(WWPlace*)place
{
    UIFont* thinFont = [UIFont fontWithName:WW_DEFAULT_FONT_NAME size:WW_SUB_LABEL_FONT_SIZE];
    UIFont* lightFont = [UIFont fontWithName:WW_DEFAULT_FONT_NAME size:WW_SUB_LABEL_FONT_SIZE];
    //UIFont* boldFont = [UIFont fontWithName:WW_BOLD_FONT_NAME size:WW_SUB_LABEL_FONT_SIZE];
    
    UIColor* baseColor = WW_LIGHT_GRAY_FONT_COLOR;
    UIColor* blackColor = [UIColor blackColor];
    UIColor* trendingColor = WW_ORANGE_FONT_COLOR;
    
    NSDictionary* baseAttrs = @{NSFontAttributeName : thinFont, NSForegroundColorAttributeName : baseColor };
    NSDictionary* blackAttrs = @{NSFontAttributeName : lightFont, NSForegroundColorAttributeName : blackColor };
    NSDictionary* trendingAttrs = @{NSFontAttributeName : lightFont, NSForegroundColorAttributeName : trendingColor };
    
    NSString* distanceString = [place formattedDistance];
    
    NSMutableString* sb = [NSMutableString string];
    [sb appendFormat:@"$$$$ • %@", distanceString];
    
    NSString* trendingString = @"Trending";
    if (place.isTrending.boolValue)
    {
        [sb appendFormat:@" • %@", trendingString];
    }
    
    NSMutableAttributedString* as = [[NSMutableAttributedString alloc] initWithString:sb attributes:nil];
    [as setAttributes:baseAttrs range:NSMakeRange(0, as.string.length)];
    [as setAttributes:blackAttrs range:NSMakeRange(0, place.price.length)];
    [as setAttributes:blackAttrs range:[sb rangeOfString:distanceString]];
    [as setAttributes:trendingAttrs range:[sb rangeOfString:trendingString]];
    
    self.infoLabel.attributedText = as;
}

@end
