//
//  WWSignInViewController.m
//  WayWay
//
//  Created by Ryan DeVore on 11/1/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWSignInViewController ()

@property (assign) BOOL isLoggingIn;
@property (assign) CGPoint viewCenter;

@end

@implementation WWSignInViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.statusLabel.text = @"";
    
    [self.statusLabel wwStyleWithFontOfSize:14];
    [self.progressLabel wwStyleWithFontOfSize:14];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 15, 10, 10);
    
    self.registerEmailField.contentInsets = insets;
    self.registerPasswordOneField.contentInsets = insets;
    
    [self.loginButton wwStyleFlatWhiteButtonWithGreenText];
    
    self.registerEmailField.font = [UIFont fontWithName:WW_DEFAULT_FONT_NAME size:16];
    self.registerPasswordOneField.font = [UIFont fontWithName:WW_DEFAULT_FONT_NAME size:16];
    
    self.navigationItem.leftBarButtonItem = [self wwBackNavItem];
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
    
    [self onDismissKeyboard:nil];
    
    [self updateSignUpButton];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)onLoginClicked:(id)sender
{
     [self showProgress:@"Logging in"];
     [self onDismissKeyboard:nil];
     
     [[WWServer sharedInstance] emailLogin:self.registerEmailField.text
                                  password:self.registerPasswordOneField.text
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
             [self dismissViewControllerAnimated:YES completion:^
             {
                 [self dismissViewControllerAnimated:YES completion:nil];
             }];
         }
     }];
}

- (void) showProgress:(NSString*)message
{
    self.view.userInteractionEnabled = NO;
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
    [self updateSignUpButton];
}

- (void) updateSignUpButton
{
    self.loginButton.enabled =
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
    
    if (textField == self.registerEmailField)
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
    UIView* referenceView = self.registerPasswordOneField;
    
    CGRect referenceFrame = referenceView.frame;
    
    CGFloat d = self.view.frame.size.height - referenceFrame.origin.y;
    
    NSDictionary *userInfo = [notification userInfo];
	CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat centerAdjust = keyboardFrame.size.height - d + referenceFrame.size.height + 15;
    CGPoint c = self.viewCenter;
    c.y -= centerAdjust;
    
    if (centerAdjust > 0)
    {
        [UIView animateWithDuration:WW_KEYBOARD_ADJUST_TRANSITION_DURATION animations:^
         {
             self.view.center = c;
         }];
    }
}

@end
