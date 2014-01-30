//
//  WWUserProfileViewController.h
//  WayWay
//
//  Created by Ryan DeVore on 7/12/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"


@interface WWUserProfileViewController : UIViewController
<
    UITableViewDataSource,
    UITableViewDelegate
>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet WWFlatButton *feedbackButton;
@property (strong, nonatomic) IBOutlet WWFlatButton *signUpButton;
@property (strong, nonatomic) IBOutlet UILabel *notLoggedInMessage;
@property (strong, nonatomic) IBOutlet WWFlatButton *inviteFriendsButton;

- (IBAction)onSignUpClicked:(id)sender;
- (IBAction)onInviteFriendsClicked:(id)sender;

@end


@interface WWGradientView : UIView
{
    
}

@property (nonatomic, retain) UIColor* beginGradientColor;
@property (nonatomic, retain) UIColor* endGradientColor;

+ (UIImage*) buildGradientView:(CGRect)rect start:(UIColor*)start end:(UIColor*)end;

@end


