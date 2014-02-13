//
//  WWListLabel.h
//  WayWay
//
//  Created by OMB Labs on 2/3/14.
//  Copyright (c) 2014 OMB Labs. All rights reserved.
//

#import "WWInclude.h"

@interface WWListLabel : UIView

@property (nonatomic, strong) UILabel* label;
@property (nonatomic, strong) UIImageView* imageView;

-(void) setAttributedText:(NSAttributedString*)attributedText andImage:(UIImage *)image;
@end
