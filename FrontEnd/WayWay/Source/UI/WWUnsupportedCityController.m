//
//  WWUnsupportedCityController.m
//  WayWay
//
//  Created by OMB Labs on 2/11/14.
//  Copyright (c) 2014 OMB Labs. All rights reserved.
//

#import "WWInclude.h"

@interface WWUnsupportedCityController ()

@end

@implementation WWUnsupportedCityController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.unsupportedCity setBackgroundColor:[UIColor clearColor]];
    self.unsupportedCity.text = @"You are searching in a city or area not covered by WayWay.";
    self.unsupportedCity.font = WW_FONT_H1;
    
    [self.label2 setBackgroundColor:[UIColor clearColor]];
    self.label2.text =@"We will be adding new cities soon. Stay tuned!";
    self.label2.font = WW_FONT_H1;
    
    [self.cancelButton setBackgroundColor:[UIColor clearColor]];
    [self.cancelButton.layer setBorderColor:WW_ORANGE_FONT_COLOR.CGColor];
    [self.cancelButton.layer setBorderWidth:1.0];
    [self.cancelButton.layer setCornerRadius:4.0];
    
    self.cancelButton.titleLabel.font = WW_FONT_H4;
    [self.cancelButton setTitleColor:WW_BLACK_FONT_COLOR forState:UIControlStateNormal];
    [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
}

- (IBAction)cancelPressed:(id)sender
{
    [UIView animateWithDuration:0.5f animations:^
     {
         self.view.alpha = 0;
         
     } completion:^(BOOL finished)
     {
         [self.view removeFromSuperview];
         [self removeFromParentViewController];
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
