//
//  WWPinView.m
//  WayWay
//
//  Created by Ryan DeVore on 7/5/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWPinView ()

@property (nonatomic, retain) WWPlace* place;
@property (assign) BOOL selected;

@end

@implementation WWPinView

- (void) awakeFromNib
{
    [self.trendingRankLabel wwStyleWithFontOfSize:15];
    [self.rankLabel wwStyleWithFontOfSize:15];
    self.trendingRankLabel.textColor = WW_ORANGE_FONT_COLOR;
}

- (void) update:(WWPlace*)place
{
    self.place = place;
    
    [self updateScoreLabel];
    [self updateBackgroundImage];
    [self updateCategoryIcon];
}

- (void) updateSelected:(BOOL)selected
{
    self.selected = selected;
    [self updateBackgroundImage];
}


- (void) updateScoreLabel
{
    UIFont* scoreFont = [UIFont fontWithName:WW_DEFAULT_FONT_NAME size:15];
    UIFont* percentFont = [UIFont fontWithName:WW_DEFAULT_FONT_NAME size:12];
    
    NSDictionary* scoreAttrs = @{NSFontAttributeName : scoreFont, NSForegroundColorAttributeName : [UIColor uuColorFromHex:@"333333"] };
    NSDictionary* percentAttrs = @{NSFontAttributeName : percentFont, NSForegroundColorAttributeName : [UIColor uuColorFromHex:@"333333"] };
    
    NSString* text = [NSString stringWithFormat:@"%d%%", self.place.classicRank.intValue];
    NSMutableAttributedString* as = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
    [as setAttributes:scoreAttrs range:NSMakeRange(0, as.string.length)];
    
    NSRange r = [text rangeOfString:@"%"];
    [as setAttributes:percentAttrs range:r];
    self.rankLabel.attributedText = as;
    
    self.trendingRankLabel.text = [NSString stringWithFormat:@"%d", self.place.classicRank.intValue];
    //self.rankLabel.text = [NSString stringWithFormat:@"%d%%", self.place.classicRank.intValue];
    
    self.rankLabel.hidden = (self.place.isTrending.boolValue);
    self.trendingRankLabel.hidden = !self.rankLabel.hidden;
}

- (void) updateBackgroundImage
{
    NSString* backgroundImage = nil;
    
    if (self.place.isTrending.boolValue)
    {
        if (self.selected)
        {
            backgroundImage = @"map_pointer_trending_pressed";
        }
        else
        {
            backgroundImage = @"map_pointer_trending";
        }
    }
    else
    {
        if (self.selected)
        {
            backgroundImage = @"map_pointer_pressed";
        }
        else
        {
            backgroundImage = @"map_pointer";
        }
    }
    self.backgroundView.image = [UIImage imageNamed:backgroundImage];
}

- (void) updateCategoryIcon
{
    self.categoryIcon.image = [UIImage imageNamed:self.place.categoryIcon];
}

@end


@interface WWPinAnnotationView ()

@property (nonatomic, strong) WWPinView* pinView;

@end

@implementation WWPinAnnotationView

- (id) initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.pinView = [WWPinView wwLoadFromNib];
        
        [self addSubview:self.pinView];
        self.frame = self.pinView.bounds;
        
        CGPoint pinCenter = self.pinView.center;
        CGPoint referenceTopLeft = self.pinView.centerReferenceView.frame.origin;
        
        CGPoint offset;
        offset.x = pinCenter.x - referenceTopLeft.x;
        offset.y = pinCenter.y - referenceTopLeft.y;
        
        self.centerOffset = offset;
        
        self.pinView.centerReferenceView.hidden = YES;
    }
    
    return self;
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self.pinView updateSelected:selected];
}

- (void) setAnnotation:(id<MKAnnotation>)annotation
{
    [super setAnnotation:annotation];
    
    if ([annotation isKindOfClass:[WWPlaceAnnotation class]])
    {
        WWPlaceAnnotation* a = (WWPlaceAnnotation*)annotation;
        [self.pinView update:a.place];
    }
}

@end
