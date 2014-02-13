//
//  WWUserProfileViewController.m
//  WayWay
//
//  Created by Ryan DeVore on 7/12/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

typedef enum
{
    WWUserProfileActionFindPlaces,
    WWUserProfileActionFavorites,
    WWUserProfileActionSettings,
    WWUserProfileActionTutorial
    
} WWUserProfileAction;

@interface WWUserProfileViewController ()

@property (nonatomic, strong) NSArray* tableData;

@end

@implementation WWUserProfileViewController

- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self.feedbackButton wwStyleWhiteBorderedButton];
    [self.feedbackButton setTitle:[NSString stringWithFormat:@" %@", NSLocalizedString(WW_SEND_FEEDBACK, nil)] forState:UIControlStateNormal];
    
    [self.signUpButton wwStyleWhiteBorderedButton];
    [self.signUpButton setTitle:[NSString stringWithFormat:@" %@", NSLocalizedString(WW_SIGN_IN, nil)] forState:UIControlStateNormal];
    
    
    [self.inviteFriendsButton wwStyleWhiteBorderedButton];
    [self.inviteFriendsButton setTitle:[NSString stringWithFormat:@" %@", NSLocalizedString(WW_INVITE_FRIENDS, nil)] forState:UIControlStateNormal];
    
    [self.notLoggedInMessage wwStyleWithFontOfSize:14];
    self.notLoggedInMessage.text = NSLocalizedString(WW_SIGN_IN_MESSAGE, nil);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCurrentUserChanged:) name:WW_CURRENT_USER_UPDATED_NOTIFICATION object:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /*
    UIFont* font = [UIFont fontWithName:WW_DEFAULT_FONT_NAME size:14];
    NSDictionary* attrs = @{NSFontAttributeName : font, NSForegroundColorAttributeName : [UIColor whiteColor], (NSString*)kCTUnderlineStyleAttributeName : [NSNumber numberWithInt:kCTUnderlineStyleSingle] };
    NSMutableAttributedString* as = [[NSMutableAttributedString alloc] initWithString:@"Log out" attributes:nil];
    [as setAttributes:attrs range:NSMakeRange(0, as.string.length)];
    self.signOutButton.titleLabel.attributedText = as;
    */
    
    
    UIImage* img = [WWGradientView buildGradientView:self.view.bounds start:[UIColor blackColor] end:[UIColor uuColorFromHex:@"2C4952"]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:img];
    
    [self refreshUi];
}

#pragma mark - Table callbacks

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableData.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"SelectionTableCellId";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        cell.backgroundView.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        cell.selectedBackgroundView.backgroundColor = [UIColor uuColorFromHex:@"1B1B28"];
        [cell.textLabel wwStyleWithFontOfSize:25];
    }
    
    NSDictionary* d = [self.tableData objectAtIndex:indexPath.row];
    cell.textLabel.text = d[@"name"];
    cell.imageView.image = [UIImage imageNamed:d[@"icon"]];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* d = [self.tableData objectAtIndex:indexPath.row];
    
    switch ([d[@"id"] integerValue])
    {
        case WWUserProfileActionFindPlaces:
        {
            [Flurry logEvent:WW_FLURRY_EVENT_TAP_FIND_PLACES];
            [[NSNotificationCenter defaultCenter] postNotificationName:WW_SWITCH_TO_HOME_CONTROLLER object:nil];
            break;
        }
            
        case WWUserProfileActionFavorites:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:WW_SWITCH_TO_FAVORITES_CONTROLLER object:nil];
            break;
        }
            
        case WWUserProfileActionSettings:
        {
            [Flurry logEvent:WW_FLURRY_EVENT_TAP_SETTINGS];
            [[NSNotificationCenter defaultCenter] postNotificationName:WW_SWITCH_TO_SETTINGS_CONTROLLER object:nil];
            break;
        }
        case WWUserProfileActionTutorial:
        {
            [Flurry logEvent:WW_FLURRY_EVENT_TAP_TUTORIAL];
            [[NSNotificationCenter defaultCenter] postNotificationName:WW_VIEW_INTRO_SLIDES_NOTIFICATION object:nil];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - Private helpers

- (void) refreshUi
{
    WWUser* user = [WWSettings currentUser];
    BOOL isUserSigned = (user != nil);
    
    self.signUpButton.hidden = isUserSigned;
    self.inviteFriendsButton.hidden = !isUserSigned;
    self.notLoggedInMessage.hidden = isUserSigned;
    
    //self.signOutButton.hidden = (user == nil);
    //self.userIcon.hidden = (user == nil);
    //self.usernameLabel.hidden = (user == nil);
    
    /*
    if (user)
    {
        self.usernameLabel.text = [user fullNameOrEmail];
        [self.usernameLabel wwResizeWidth];
        
        CGFloat w = self.userIcon.bounds.size.width + self.usernameLabel.bounds.size.width + 4 + self.signOutButton.bounds.size.width;
        CGFloat x = (self.view.frame.size.width - w) / 2;
        
        CGRect f = self.userIcon.frame;
        f.origin.x = x;
        self.userIcon.frame = f;
        
        f = self.usernameLabel.frame;
        f.origin.x = self.userIcon.frame.origin.x + self.userIcon.frame.size.width + 4;
        self.usernameLabel.frame = f;
        
        f = self.signOutButton.frame;
        f.origin.x = self.usernameLabel.frame.origin.x + self.usernameLabel.frame.size.width + 4;
        self.signOutButton.frame = f;
        
        self.userIcon.hidden = (self.usernameLabel.text.length <= 0);
        self.usernameLabel.hidden = (self.usernameLabel.text.length <= 0);
    }*/
    
    NSMutableArray* a = [NSMutableArray array];
    
    [a addObject:@{@"id":@(WWUserProfileActionFindPlaces), @"name": NSLocalizedString(WW_FIND_PLACES, nil), @"icon" : @"find_places" }];
    if (user)
    {
        [a addObject:@{@"id":@(WWUserProfileActionFavorites), @"name":NSLocalizedString(WW_FAVORITES, nil), @"icon" : @"favorites" }];
    }
    [a addObject:@{@"id":@(WWUserProfileActionSettings), @"name":NSLocalizedString(WW_SETTINGS, nil), @"icon" : @"settings" }];
    [a addObject:@{@"id":@(WWUserProfileActionTutorial), @"name":NSLocalizedString(WW_TUTORIAL, nil), @"icon" : @"tutorial" }];
    self.tableData = a;
    
    [self.tableView reloadData];
}

#pragma mark - UI Event Handlers
- (IBAction)onSendFeedbackClicked:(id)sender
{
    [Flurry logEvent:WW_FLURRY_EVENT_TAP_FEEDBACK];
    [[NSNotificationCenter defaultCenter] postNotificationName:WW_SWITCH_TO_SENDFEEDBACK_CONTROLLER object:nil];

}

- (IBAction)onSignUpClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:WW_SWITCH_TO_LOGIN_CONTROLLER object:nil];
}

- (IBAction)onSignOutClicked:(id)sender
{
    [WWSettings setCurrentUser:nil];
    [self refreshUi];
}

- (IBAction)onInviteFriendsClicked:(id)sender
{
    [Flurry logEvent:WW_FLURRY_EVENT_INVITE_FRIENDS];
    
    NSArray* items = @[ WW_SHARE_SMS_BODY ];
    
    UIActivityViewController* v = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    v.completionHandler = ^(NSString *activityType, BOOL completed)
    {
        WWDebugLog(@"Sharing for %@, completed: %d", activityType, completed);
    };
    
    [self presentViewController:v animated:YES completion:nil];
}

#pragma mark - Notification Handlers

- (void)handleCurrentUserChanged:(NSNotification*)notification
{
    [self refreshUi];
}

/*- (BOOL) prefersStatusBarHidden
{
    return YES;
}*/

@end

@implementation WWGradientView

- (void) drawRect:(CGRect)rect
{
}


+ (UIImage*) buildGradientView:(CGRect)rect start:(UIColor*)start end:(UIColor*)end
{
    UIGraphicsBeginImageContext(rect.size);
    
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, rect);
	CGPathCloseSubpath(path);
    
	//[self.shadeColor set];
    
    CGContextSaveGState(context);
	CGContextAddPath(context, path);
    CGPathRelease(path);
    
    //if (self.useGradient)
    {
        CGContextClip(context);
        
        int numComponents = 0;
        
        CGFloat beginRed = 0.0f, beginGreen = 0.0f, beginBlue = 0.0f, beginAlpha = 1.0f;
        CGFloat endRed = 0.0f, endGreen = 0.0f, endBlue = 0.0f, endAlpha = 1.0f;
        
        numComponents = CGColorGetNumberOfComponents(start.CGColor);
        const float* colors = CGColorGetComponents(start.CGColor);
        if (numComponents == 2)
        {
            beginRed = colors[0];
            beginGreen = colors[0];
            beginBlue = colors[0];
            beginAlpha = colors[1];
        }
        else if (numComponents == 4)
        {
            beginRed = colors[0];
            beginGreen = colors[1];
            beginBlue = colors[2];
            beginAlpha = colors[3];
        }
        
        numComponents = CGColorGetNumberOfComponents(end.CGColor);
        colors = CGColorGetComponents(end.CGColor);
        if (numComponents == 2)
        {
            endRed = colors[0];
            endGreen = colors[0];
            endBlue = colors[0];
            endAlpha = colors[1];
        }
        else if (numComponents == 4)
        {
            endRed = colors[0];
            endGreen = colors[1];
            endBlue = colors[2];
            endAlpha = colors[3];
        }
        
        
        CGFloat gradientColors [] =
        {
            beginRed, beginGreen, beginBlue, beginAlpha,
            endRed, endGreen, endBlue, endAlpha,
        };
        
        CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, gradientColors, NULL, 2);
        CGColorSpaceRelease(baseSpace);
        
        CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
        CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
        
        CGContextDrawLinearGradient (context, gradient, startPoint, endPoint, 0);
        CGGradientRelease(gradient);
    }
    //else
    //{
     //   CGContextFillPath(context);
    //}
    
    CGContextRestoreGState(context);
    
    UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}


@end
