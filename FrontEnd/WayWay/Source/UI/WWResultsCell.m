//
//  WWResultsCell.m
//  WayWay
//
//  Created by Ryan DeVore on 5/31/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"
#import "WWImageDownloader.h"

@interface WWResultsCell ()

@property (strong, nonatomic) WWPlace* place;

@end

@implementation WWResultsCell

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    [self.nameLabel wwStyleWithBoldFontOfSize:20];
    
    [self.categoryLabel wwStyleWithFontOfSize:WW_SUB_LABEL_FONT_SIZE];
    [self.distanceLabel wwStyleWithFontOfSize:WW_SUB_LABEL_FONT_SIZE];
    [self.priceLabel wwStyleWithFontOfSize:WW_SUB_LABEL_FONT_SIZE];
    
    UIFont* baseFont = [UIFont fontWithName:WW_DEFAULT_BOLD_FONT_NAME size:WW_SUB_LABEL_FONT_SIZE];
    [self.hashtagmentions wwStyleWithFontOfSize:WW_SUB_LABEL_FONT_SIZE];
    self.hashtagmentions.font = baseFont;
    
    [self wwStyleWithTopAndBottomBorder:[UIColor blackColor] width:1];
}

- (void) update:(WWPlace*)place hashtag:(NSString*)hashtag
{
    self.place = place;
    
    self.nameLabel.text = [place.name uppercaseString];
    self.categoryLabel.text = place.combinedCategories;
    self.priceLabel.text = place.price;
    self.distanceLabel.text = [place formattedDistance];
    
    if(hashtag)
    {
        //display number of occurences in list
        NSString* text = [NSString stringWithFormat:@"#%@ - %d mentions", hashtag, place.hashtagMentions.intValue];
        self.hashtagmentions.text = text;
    }
    else
    {
        self.hashtagmentions.text = nil;
    }
    
    [self refreshScoreLabel];
    [self refreshPriceLabel];
    
    NSURL* bannerUrl = [NSURL URLWithString:self.place.bannerUrl];
    BOOL alreadyExists = [UUDataCache uuDoesCachedDataExistForURL:bannerUrl];
    if (!alreadyExists)
    {
        self.bannerView.alpha = 0;
    }
    else
    {
        self.bannerView.alpha = 1;
    }
    
    UIImage* defaultImg = [UIImage wwSolidColorImage:[UIColor uuColorFromHex:@"333333"]];
    self.bannerView.image = defaultImg;
    
    //WWDebugLog(@"place: %@ banner url: %@", self.place.name, bannerUrl);
    
    if (bannerUrl)
    {
        [WWImageDownloader downloadImage:bannerUrl photoId:nil completion:^( BOOL success, UIImage *image)
         {
             if(![self.place.bannerUrl isEqualToString:[bannerUrl absoluteString]])
                 return;
             
             if(success && (image!= nil))
             {
                 self.bannerView.image = image;
                 
                 if (!alreadyExists)
                 {
                     [UIView animateWithDuration:0.15f animations:^
                      {
                          self.bannerView.alpha = 1;
                      }];
                 }
             }
         }];
    }
    else
    {
        WWDebugLog(@" ***** WARNING ***** Banner URL for %@ is nil", self.place.name);
        self.bannerView.alpha = 1;
    }
    
    self.trendingIcon.hidden = !self.place.isTrending.boolValue;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    [self.nameLabel wwResizeWidthAndHeight];
    
    CGRect f = self.nameLabel.frame;
    f.origin.y = self.categoryLabel.frame.origin.y - f.size.height;
    self.nameLabel.frame = f;
    
    [self.scoreLabel wwResizeWidth];
    
    f = self.trendingIcon.frame;
    f.origin.x = self.scoreLabel.frame.origin.x + f.size.width - 4;
    self.trendingIcon.frame = f;
}

- (void) refreshPriceLabel
{
    UIFont* thinFont = [UIFont fontWithName:WW_DEFAULT_FONT_NAME size:WW_SUB_LABEL_FONT_SIZE];
    UIFont* lightFont = [UIFont fontWithName:WW_DEFAULT_FONT_NAME size:WW_SUB_LABEL_FONT_SIZE];
    
    UIColor* baseColor = [[UIColor whiteColor] colorWithAlphaComponent:.3f];
    UIColor* highlightColor = [UIColor whiteColor];
    
    NSDictionary* baseAttrs = @{NSFontAttributeName : thinFont, NSForegroundColorAttributeName : baseColor };
    NSDictionary* highlightAttrs = @{NSFontAttributeName : lightFont, NSForegroundColorAttributeName : highlightColor };
    
    NSString* text = @"$$$$";
    
    NSMutableAttributedString* as = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
    [as setAttributes:baseAttrs range:NSMakeRange(0, as.string.length)];
    [as setAttributes:highlightAttrs range:NSMakeRange(0, self.place.price.length)];
    
    self.priceLabel.attributedText = as;
}

- (void) refreshScoreLabel
{
    UIFont* baseFont = [UIFont fontWithName:WW_DEFAULT_FONT_NAME size:WW_HEADING_FONT_SIZE];
    UIFont* percentFont = [UIFont fontWithName:WW_DEFAULT_FONT_NAME size:WW_SUB_LABEL_FONT_SIZE];
    
    NSDictionary* baseAttrs = @{NSFontAttributeName : baseFont, NSForegroundColorAttributeName : [UIColor whiteColor] };
    NSDictionary* percentAttrs = @{NSFontAttributeName : percentFont, NSForegroundColorAttributeName : [UIColor whiteColor] };
    
    NSString* sb = [NSString stringWithFormat:@"%d%%", self.place.classicRank.integerValue];
    if (self.place.isTrending.boolValue)
    {
        sb = [NSString stringWithFormat:@"%d", self.place.classicRank.integerValue];
    }
    
    NSMutableAttributedString* as = [[NSMutableAttributedString alloc] initWithString:sb attributes:nil];
    [as setAttributes:baseAttrs range:NSMakeRange(0, as.string.length)];
    [as setAttributes:percentAttrs range:[sb rangeOfString:@"%"]];
    
    self.scoreLabel.attributedText = as;
}

@end
