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
    self.categoriesLabel.font = WW_FONT_H6;
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
    UIColor* baseColor = WW_LIGHT_GRAY_FONT_COLOR;
    UIColor* blackColor = [UIColor blackColor];
    UIColor* trendingColor = WW_ORANGE_FONT_COLOR;
    
    NSDictionary* baseAttrs = @{NSFontAttributeName : WW_FONT_H6, NSForegroundColorAttributeName : baseColor };
    NSDictionary* blackAttrs = @{NSFontAttributeName : WW_FONT_H6, NSForegroundColorAttributeName : blackColor };
    NSDictionary* trendingAttrs = @{NSFontAttributeName : WW_FONT_H6, NSForegroundColorAttributeName : trendingColor };
    
    NSDictionary* pointAttrs = @{NSFontAttributeName : WW_FONT_H6, NSForegroundColorAttributeName : WW_LIGHT_GRAY_BUTTON_COLOR};
    
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
    [as setAttributes:pointAttrs range:[sb rangeOfString:@"•"]];
    
    self.infoLabel.attributedText = as;
}

@end
