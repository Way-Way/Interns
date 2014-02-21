//
//  WWLoginViewController.h
//  WayWay
//
//  Created by Ryan DeVore on 7/24/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWLoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *facebookButton;

@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UILabel *signUpMessage;

@property (weak, nonatomic) IBOutlet WWTextField *registerFullNameField;
@property (weak, nonatomic) IBOutlet WWTextField *registerEmailField;
@property (weak, nonatomic) IBOutlet WWTextField *registerPasswordOneField;

@property (weak, nonatomic) IBOutlet UIButton *registerSignUpButton;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIView *progressContainer;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressSpinner;


@property (weak, nonatomic) IBOutlet UIButton *loginFromRegisterButton;




- (IBAction)onFacebookClicked:(id)sender;
- (IBAction)onRegisterSignUpClicked:(id)sender;
- (IBAction)onRegisterAlreadyAMemberClicked:(id)sender;
- (IBAction)onDismissKeyboard:(id)sender;

@end
