//
//  WWLoginViewController.m
//  WayWay
//
//  Created by Ryan DeVore on 7/24/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWLoginViewController ()

@property (assign) BOOL isLoggingIn;
@property (assign) CGPoint viewCenter;

@end

@implementation WWLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.statusLabel.text = @"";
    
    self.statusLabel.font = WW_FONT_H6;
    self.progressLabel.font = WW_FONT_H6;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 15, 10, 10);
    
    self.registerFullNameField.contentInsets = insets;
    self.registerEmailField.contentInsets = insets;
    self.registerPasswordOneField.contentInsets = insets;
    
    self.facebookButton.titleLabel.font = WW_FONT_H4;
    [self.facebookButton setTitleColor:WW_FACEBOOK_BLUE_COLOR forState:UIControlStateNormal];
    [self.facebookButton setTitleColor:WW_GRAY_COLOR_7 forState:UIControlStateHighlighted];
    [self.facebookButton wwStyleLightGreyTopAndBottomBorders];
    
    self.messageLabel.font = WW_FONT_H6;
    self.signUpMessage.font = WW_FONT_H3;
    
    self.messageLabel.textColor = WW_GRAY_COLOR_7;
    
    self.registerFullNameField.font = WW_FONT_H4;
    self.registerEmailField.font = WW_FONT_H4;
    self.registerPasswordOneField.font = WW_FONT_H4;
    
    [self.registerSignUpButton wwStyleFlatWhiteButtonWithGreenText];
    [self.loginFromRegisterButton wwStyleFlatWhiteButtonWithBlackText];
    
    self.navigationItem.leftBarButtonItem = [self wwCloseNavItem];
    self.navigationItem.titleView = [self wwCenterNavItem:@"Sign In"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    if (self.viewCenter.x == 0)
    {
        self.viewCenter = self.view.center;
    }
    
    if (!self.isLoggingIn)
    {
        [self hideProgress:nil];
    }
    
    self.registerEmailField.text = @"";
    self.registerPasswordOneField.text = @"";
    self.registerFullNameField.text = @"";
    
    [self onDismissKeyboard:nil];
    
    [self updateSignUpButton];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)onFacebookClicked:(id)sender
{
    [self showProgress:@"Logging in"];
    [self onDismissKeyboard:nil];
    [FBSession openActiveSessionWithPublishPermissions:nil
                                       defaultAudience:FBSessionDefaultAudienceEveryone
                                          allowLoginUI:YES
                                     completionHandler:^(FBSession *session, FBSessionState status, NSError *error)
    {
        WWDebugLog(@"FB access token: %@", session.accessTokenData.accessToken);
        
        if (!error)
        {
            [[WWServer sharedInstance] facebookLogin:session.accessTokenData.accessToken
                               accessTokenExpiration:session.accessTokenData.expirationDate
                                   completionHandler:^(NSError *error, WWUser *updatedUser)
            {
                WWDebugLog(@"User: %@", updatedUser);
                
                if (error)
                {
                    [self hideProgress:@"Unable to login, please try again."];
                }
                else
                {
                    [self hideProgress:@"User logged in."];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }];
        }
        else
        {
            WWDebugLog(@"Facebook Auth Error: %@", error);
            [self hideProgress:@"Unable to login, please try again."];
        }
    }];
}

- (IBAction)onRegisterSignUpClicked:(id)sender
{
    self.isLoggingIn = YES;
    [self showProgress:@"Signing up"];
    [self onDismissKeyboard:nil];
    
    [[WWServer sharedInstance] registerUser:self.registerEmailField.text
                                   password:self.registerPasswordOneField.text
                                   fullName:self.registerFullNameField.text
                          completionHandler:^(NSError *error, WWUser *updatedUser)
    {
        WWDebugLog(@"User: %@", updatedUser);
        
        if (error)
        {
            [self hideProgress:@"Unable to register, please try again."];
        }
        else
        {
            [self hideProgress:@"User registered."];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (IBAction)onRegisterAlreadyAMemberClicked:(id)sender
{
    [Flurry logEvent:WW_FLURRY_EVENT_TAP_ALREADY_HAVE_ACCOUNT];
    
    WWSignInViewController* c = [WWSignInViewController new];
    [self.navigationController pushViewController:c animated:YES];
}

- (void) showProgress:(NSString*)message
{
    self.view.userInteractionEnabled = NO;
    self.registerSignUpButton.hidden = YES;
    self.statusLabel.alpha = 0;
    self.statusLabel.text = @"";
    self.isLoggingIn = YES;
    
    self.progressLabel.text = message;
    [self.progressSpinner startAnimating];
    [UIView animateWithDuration:0.3f animations:^
     {
         self.progressContainer.alpha = 1;
     }];
}

- (void) hideProgress:(NSString*)statusMessage
{
    [UIView animateWithDuration:0.3f animations:^
     {
         self.progressContainer.alpha = 0;
     }
    completion:^(BOOL finished)
    {
        [self.progressSpinner stopAnimating];
        self.view.userInteractionEnabled = YES;
        self.registerSignUpButton.hidden = NO;
        self.statusLabel.alpha = 1;
        self.isLoggingIn = NO;
        self.statusLabel.text = statusMessage;
        
        if (statusMessage)
        {
            [UIView animateWithDuration:0.3f animations:^
             {
                 self.statusLabel.alpha = 1;
             }];
        }
    }];
}

- (IBAction)onDismissKeyboard:(id)sender
{
    [self.registerEmailField resignFirstResponder];
    [self.registerPasswordOneField resignFirstResponder];
    [self.registerFullNameField resignFirstResponder];
    [self updateSignUpButton];
}

- (void) updateSignUpButton
{
    self.registerSignUpButton.enabled =
        self.registerFullNameField.text.length > 0 &&
        self.registerEmailField.text.length > 0 &&
        self.registerPasswordOneField.text.length > 0;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self updateSignUpButton];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self updateSignUpButton];
    
    if (textField == self.registerFullNameField)
    {
        [self.registerEmailField becomeFirstResponder];
    }
    else if (textField == self.registerEmailField)
    {
        [self.registerPasswordOneField becomeFirstResponder];
    }
    else if (textField == self.registerPasswordOneField)
    {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:WW_KEYBOARD_ADJUST_TRANSITION_DURATION animations:^
     {
         self.view.center = self.viewCenter;
     }];
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    CGFloat destY = self.signUpMessage.frame.origin.y + self.signUpMessage.frame.size.height;
    CGFloat srcY = self.viewCenter.y;
    
    CGFloat centerAdjust = self.viewCenter.y - self.signUpMessage.frame.origin.y + self.signUpMessage.frame.size.height;//   keyboardFrame.size.height - d + referenceFrame.size.height + 15;
    CGPoint c = self.viewCenter;
    c.y = srcY - destY + 70; // nav, status and a little margin
    
    if (centerAdjust > 0)
    {
        [UIView animateWithDuration:WW_KEYBOARD_ADJUST_TRANSITION_DURATION animations:^
         {
             self.view.center = c;
         }];
    }
}

/*- (BOOL) prefersStatusBarHidden
{
    return NO;
}*/

@end
