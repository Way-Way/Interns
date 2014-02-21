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
    
    self.nameLabel.font = WW_FONT_H2;
    self.distanceLabel.font = WW_FONT_H5;
    
    self.categoryLabel.font = WW_FONT_H5;
    [self.categoryLabel wwRepositionSizeHeight];
    
    self.priceLabel.font = WW_FONT_H5;
    [self.priceLabel wwRepositionSizeHeight];
    
    self.listLabel = [[WWListLabel alloc] init];
    [self addSubview:self.listLabel];
    
    
    [self wwStyleWithTopAndBottomBorder:[UIColor blackColor] width:1];
}

- (void) update:(WWPlace*)place hashtag:(NSString*)hashtag displayLabel:(BOOL)displayLabel
{
    self.place = place;
    
    self.nameLabel.text = [place.name uppercaseString];
    self.categoryLabel.text = place.combinedCategories;
    self.priceLabel.text = place.price;
    self.distanceLabel.text = [place formattedDistance];
    
    NSString* text;
    
    NSDictionary* baseAttrs = @{NSFontAttributeName : WW_FONT_H5, NSForegroundColorAttributeName : WW_BLACK_FONT_COLOR };
    
    NSMutableAttributedString* attirbutedtext;
    
    if(hashtag)
    {
        //display number of occurences in list
        text = [NSString stringWithFormat:@"%@", [place.hashtagMentions.stringValue wwFormatAsMentionsSummary]];
        attirbutedtext = [[NSMutableAttributedString alloc ] initWithString:text];
        [attirbutedtext setAttributes:baseAttrs range:NSMakeRange(0, text.length)];
        
        UIImage* icon = [UIImage imageNamed:@"photo_counter"];
        
        [self.listLabel setAttributedText:attirbutedtext andImage:icon];
    }
    else
    {
        text = [NSString stringWithFormat:@"%.1f", place.classicRank.doubleValue];
        attirbutedtext = [[NSMutableAttributedString alloc ] initWithString:text];
        [attirbutedtext setAttributes:baseAttrs range:NSMakeRange(0, text.length)];
    
        
        [self.listLabel setAttributedText:attirbutedtext andImage:nil];
    }
    
    self.listLabel.frame = CGRectMake(15, 10, self.listLabel.frame.size.width, self.listLabel.frame.size.height);
    self.listLabel.hidden = !displayLabel;
    
    //[self refreshScoreLabel];
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
    
    //self.trendingIcon.hidden = !self.place.isTrending.boolValue;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    [self.nameLabel wwResizeWidthAndHeight];
    
    CGRect f = self.nameLabel.frame;
    f.origin.y = self.categoryLabel.frame.origin.y - f.size.height;
    self.nameLabel.frame = f;
    
    //[self.scoreLabel wwResizeWidth];
    
    //f = self.trendingIcon.frame;
    //f.origin.x = self.scoreLabel.frame.origin.x + f.size.width - 4;
    //self.trendingIcon.frame = f;
}

- (void) refreshPriceLabel
{
    UIColor* baseColor = [[UIColor whiteColor] colorWithAlphaComponent:.3f];
    UIColor* highlightColor = [UIColor whiteColor];
    
    NSDictionary* baseAttrs = @{NSFontAttributeName : WW_FONT_H5, NSForegroundColorAttributeName : baseColor };
    NSDictionary* highlightAttrs = @{NSFontAttributeName : WW_FONT_H5, NSForegroundColorAttributeName : highlightColor };
    
    NSString* text = @"$$$$";
    
    NSMutableAttributedString* as = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
    [as setAttributes:baseAttrs range:NSMakeRange(0, as.string.length)];
    [as setAttributes:highlightAttrs range:NSMakeRange(0, self.place.price.length)];
    
    self.priceLabel.attributedText = as;
}

@end
