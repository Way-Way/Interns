//
//  WWIntroViewController.h
//  WayWay
//
//  Created by Ryan DeVore on 12/17/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWIntroViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *scrollContent;
@property (strong, nonatomic) IBOutlet UIButton *exitSearchButtonOne;
@property (strong, nonatomic) IBOutlet UIButton *exitSearchButtonTwo;
@property (strong, nonatomic) IBOutlet UIButton *exitSearchButtonThree;
@property (strong, nonatomic) IBOutlet UIButton *exitSearchButtonFour;
@property (strong, nonatomic) IBOutlet UIButton *exitSearchButtonFive;
@property (strong, nonatomic) IBOutlet UIButton *skipIntroButton;
@property (strong, nonatomic) IBOutlet UIImageView *dotsView;
@property (nonatomic, copy) void (^dismissCallback)(BOOL cancelled);

- (IBAction)onExitSearchButtonOne:(id)sender;
- (IBAction)onExitSearchButtonTwo:(id)sender;
- (IBAction)onExitSearchButtonThree:(id)sender;
- (IBAction)onExitSearchButtonFour:(id)sender;
- (IBAction)onExitSearchButtonFive:(id)sender;
- (IBAction)onExitIntro:(id)sender;

-(void) resetIntro;

@end
