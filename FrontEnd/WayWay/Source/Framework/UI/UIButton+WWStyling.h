//
//  UIButton+WWStyling.h
//  WayWay
//
//  Created by Ryan DeVore on 11/2/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface UIButton (WWStyling)

- (void) wwStyleLightBlueButton;
- (void) wwStyleLightGrayAndOrangeButton;
- (void) wwStyleFlatWhiteButtonWithBlackText;
- (void) wwStyleFlatWhiteButtonWithGreenText;
- (void) wwStyleFlatWhiteButtonWithGrayText;
- (void) wwStyleWhiteBorderedButton;

@end


@interface WWFlatButton : UIButton

@property (assign) CGFloat borderRadius;
@property (assign) CGFloat borderWidth;

@property (assign) UIColor* normalBorderColor;
@property (assign) UIColor* normalBackgroundColor;

@property (assign) UIColor* selectedBorderColor;
@property (assign) UIColor* selectedBackgroundColor;

@end


@interface UIColor (WWStyling)

-(UIColor*) wwDarkerShade;

@end

