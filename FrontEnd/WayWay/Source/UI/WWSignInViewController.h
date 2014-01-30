//
//  WWSignInViewController.h
//  WayWay
//
//  Created by Ryan DeVore on 11/1/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWSignInViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *progressContainer;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressSpinner;
@property (weak, nonatomic) IBOutlet WWTextField *registerEmailField;
@property (weak, nonatomic) IBOutlet WWTextField *registerPasswordOneField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

- (IBAction)onLoginClicked:(id)sender;
- (IBAction)onDismissKeyboard:(id)sender;

@end
