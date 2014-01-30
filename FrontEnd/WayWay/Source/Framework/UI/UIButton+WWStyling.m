//
//  UIButton+WWStyling.m
//  WayWay
//
//  Created by Ryan DeVore on 11/2/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@implementation UIButton (WWStyling)

- (void) wwStyleLightBlueButton
{
    UIImage* selectedImage = [UIImage wwSolidColorImage:WW_LIGHT_BLUE_COLOR];
    UIImage* unselectedImage = [UIImage wwSolidColorImage:[UIColor whiteColor]];
    UIImage* pressedImage = [UIImage wwSolidColorImage:WW_GRAY_BACKGROUND];
    
    [self setBackgroundImage:selectedImage forState:UIControlStateSelected];
    [self setBackgroundImage:unselectedImage forState:UIControlStateNormal];
    [self setBackgroundImage:pressedImage forState:UIControlStateHighlighted];
    
    [self setTitleColor:WW_LIGHT_BLUE_COLOR forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    [self.titleLabel wwStyleWithFontOfSize:16];
}

- (void) wwStyleLightGrayAndOrangeButton
{
    self.backgroundColor = [UIColor clearColor];
    
    UIImage* unselectedImage = [UIImage wwSolidColorImage:[UIColor clearColor]];
    UIImage* selectedImage = [UIImage wwSolidColorImage:WW_ORANGE_FONT_COLOR];
    UIImage* pressedImage = [UIImage wwSolidColorImage:WW_GRAY_BACKGROUND];
    
    [self setBackgroundImage:selectedImage forState:UIControlStateSelected];
    [self setBackgroundImage:unselectedImage forState:UIControlStateNormal];
    [self setBackgroundImage:pressedImage forState:UIControlStateHighlighted];
    
    [self setTitleColor:WW_LIGHT_GRAY_BUTTON_COLOR forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    [self.titleLabel wwStyleWithFontOfSize:16];
    
    if ([self isKindOfClass:[WWFlatButton class]])
    {
        WWFlatButton* b = (WWFlatButton*)self;
        b.normalBackgroundColor = [UIColor clearColor];
        b.normalBorderColor = WW_LIGHT_GRAY_BUTTON_COLOR;
        b.selectedBackgroundColor = WW_ORANGE_FONT_COLOR;
        b.selectedBorderColor = WW_ORANGE_FONT_COLOR;
    }
}

- (void) wwStyleWhiteBorderedButton
{
    [self wwStyleWhiteButtonBorder];
    
    self.backgroundColor = [UIColor clearColor];
    
    UIImage* unselectedImage = [UIImage wwSolidColorImage:[UIColor clearColor]];
    UIImage* pressedImage = [UIImage wwSolidColorImage:[UIColor whiteColor]];
    
    [self setBackgroundImage:unselectedImage forState:UIControlStateNormal];
    [self setBackgroundImage:pressedImage forState:UIControlStateHighlighted];
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    [self.titleLabel wwStyleWithFontOfSize:16];
    
    if ([self isKindOfClass:[WWFlatButton class]])
    {
        WWFlatButton* b = (WWFlatButton*)self;
        b.normalBackgroundColor = [UIColor clearColor];
        b.normalBorderColor = [UIColor whiteColor];
        b.selectedBackgroundColor = [UIColor whiteColor];
        b.selectedBorderColor = [UIColor whiteColor];
    }
}

- (void) wwStyleFlatWhiteButtonWithBlackText
{
    UIImage* selectedImage = [UIImage wwSolidColorImage:[UIColor whiteColor]];
    UIImage* pressedImage = [UIImage wwSolidColorImage:[UIColor blackColor]];
    
    [self setBackgroundImage:selectedImage forState:UIControlStateSelected];
    [self setBackgroundImage:pressedImage forState:UIControlStateHighlighted];
    
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [self.titleLabel wwStyleWithFontOfSize:16];
    
    [self wwStyleLightGreyTopAndBottomBorders];
}

- (void) wwStyleFlatWhiteButtonWithGreenText
{
    UIImage* selectedImage = [UIImage wwSolidColorImage:[UIColor whiteColor]];
    UIImage* pressedImage = [UIImage wwSolidColorImage:WW_GREEN_BUTTON_COLOR];
    
    [self setBackgroundImage:selectedImage forState:UIControlStateSelected];
    [self setBackgroundImage:pressedImage forState:UIControlStateHighlighted];
    
    [self setTitleColor:WW_GREEN_BUTTON_COLOR forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [self.titleLabel wwStyleWithFontOfSize:16];
    [self wwStyleLightGreyTopAndBottomBorders];
}

- (void) wwStyleFlatWhiteButtonWithGrayText
{
    self.backgroundColor = [UIColor clearColor];
    
    UIImage* unselectedImage = [UIImage wwSolidColorImage:[UIColor clearColor]];
    UIImage* selectedImage = [UIImage wwSolidColorImage:WW_ORANGE_FONT_COLOR];
    UIImage* pressedImage = [UIImage wwSolidColorImage:WW_GRAY_BACKGROUND];
    
    [self setBackgroundImage:selectedImage forState:UIControlStateSelected];
    [self setBackgroundImage:unselectedImage forState:UIControlStateNormal];
    [self setBackgroundImage:pressedImage forState:UIControlStateHighlighted];
    
    [self setTitleColor:WW_LIGHT_GRAY_BUTTON_COLOR forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    [self.titleLabel wwStyleWithFontOfSize:16];

    [self wwStyleLightGreyTopAndBottomBorders];
}

@end




@interface WWFlatButton ()

@end

@implementation WWFlatButton

-(void) setHighlighted:(BOOL)highlighted
{
    if (highlighted)
    {
        //self.backgroundColor = [self.normalBackgroundColor wwDarkerShade];
        //self.layer.borderColor = [[self.normalBorderColor wwDarkerShade] CGColor];
        
    }
    else
    {
        //self.backgroundColor = self.normalBackgroundColor;
        //self.layer.borderColor = [self.normalBorderColor CGColor];
    }
    
    [super setHighlighted:highlighted];
}

-(void) setSelected:(BOOL)selected
{
    if(selected)
    {
        //self.backgroundColor = self.selectedBackgroundColor;
        //self.layer.borderColor = [self.selectedBorderColor CGColor];
        self.layer.borderWidth = 0;
    }
    else
    {
        self.layer.borderWidth = 1;
        //self.backgroundColor = self.normalBackgroundColor;
        //self.layer.borderColor = [self.normalBorderColor CGColor];
    }
    
    [super setSelected:selected];
}

@end

@implementation UIColor (WWStyling)

-(UIColor*) wwDarkerShade
{
    float red, green, blue, alpha;
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    
    double multiplier = 0.8f;
    return [UIColor colorWithRed:red * multiplier green:green * multiplier blue:blue*multiplier alpha:alpha];
}

@end

