//
//  WWListLabel.m
//  WayWay
//
//  Created by OMB Labs on 2/3/14.
//  Copyright (c) 2014 OMB Labs. All rights reserved.
//

#import "WWInclude.h"

@implementation WWListLabel

const int verticalInset = 3;
const int horizontalInset = 5;
const int spacing = 4;

- (id)init
{
    self = [super init];
    if (self)
    {
        // Initialization code
        self.layer.cornerRadius = 2.0f;
        self.backgroundColor = [UIColor whiteColor];
        
        self.label = [[UILabel alloc] init];
        [self addSubview:self.label];
        
        self.imageView = [[UIImageView alloc] init];
        [self addSubview:self.imageView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


-(void) setAttributedText:(NSAttributedString*)attributedText andImage:(UIImage *)image
{
    [self.label setAttributedText:attributedText];
    [self.label sizeToFit];
    
    CGRect textFrame = self.label.frame;

    
    CGFloat width;
    CGFloat height;
    
    if(image)
    {
        width = 2 * horizontalInset + textFrame.size.width + image.size.width + spacing;
        height = 2 * verticalInset + MAX(textFrame.size.height, image.size.height);
    }
    else
    {
        width = 2 * horizontalInset + textFrame.size.width;
        height = 2 * verticalInset + textFrame.size.height;
    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, height);
    self.label.frame = CGRectMake(horizontalInset, verticalInset, textFrame.size.width, textFrame.size.height);
    
    [self.imageView setImage:image];
    self.imageView.frame = CGRectMake(horizontalInset + textFrame.size.width + spacing,
                                      (self.frame.size.height - image.size.height)/2.0,
                                      image.size.width,
                                      image.size.height);
}



@end
