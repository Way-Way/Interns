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
    self.rankLabel.font = WW_FONT_H5;
}

- (void) update:(WWPlace*)place
{
    self.place = place;
    
    [self updateScoreLabel];
    [self updateBackgroundImage];
}

- (void) updateSelected:(BOOL)selected
{
    self.selected = selected;
    [self updateBackgroundImage];
}


- (void) updateScoreLabel
{
    UIColor*color = WW_GRAY_COLOR_11;
    if([self.place.isTrending boolValue])
        color = WW_LEAD_COLOR;
    
    
    NSDictionary* scoreAttrs = @{NSFontAttributeName : WW_FONT_H5, NSForegroundColorAttributeName : color };
    
    NSString* text = [NSString stringWithFormat:@"%.1f", self.place.classicRank.doubleValue];
    NSMutableAttributedString* as = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
    [as setAttributes:scoreAttrs range:NSMakeRange(0, as.string.length)];
    
    self.rankLabel.attributedText = as;
}

- (void) updateBackgroundImage
{
    NSString* backgroundImage = nil;
    
    switch (self.place.category)
    {
        case WWBarCategory:
            if (self.selected)
            {
                backgroundImage = @"map_bar_selected";
            }
            else
            {
                backgroundImage = @"map_bar";
            }
            break;
        case WWRestaurantCategory:
            if (self.selected)
            {
                backgroundImage = @"map_restaurant_selected";
            }
            else
            {
                backgroundImage = @"map_restaurant";
            }
            break;
        case WWSnackCategory:
            if (self.selected)
            {
                backgroundImage = @"map_snack_selected";
            }
            else
            {
                backgroundImage = @"map_snack";
            }
            break;
        case WWCoffeeCategory:
            if (self.selected)
            {
                backgroundImage = @"map_coffee_selected";
            }
            else
            {
                backgroundImage = @"map_coffee";
            }
            break;
        default:
            //What do we put here ??
            if (self.selected)
            {
                backgroundImage = @"map_restaurant_selected";
            }
            else
            {
                backgroundImage = @"map_restaurant";
            }
            break;
    }
    
    self.backgroundView.image = [UIImage imageNamed:backgroundImage];
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
