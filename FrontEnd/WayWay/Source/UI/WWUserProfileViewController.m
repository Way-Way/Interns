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
    WWUserProfileActionTutorial,
    WWUserProfileSignIn,
    WWUserProfileInviteFriends,
    WWUserProfileSendFeedback
} WWUserProfileAction;

@interface WWUserProfileViewController ()

@property (nonatomic, strong) NSArray* tableDataFirst;
@property (nonatomic, strong) NSArray* tableDataSecond;

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
    
    /*[self.feedbackButton wwStyleWhiteBorderedButton];
    [self.feedbackButton setTitle:[NSString stringWithFormat:@" %@", NSLocalizedString(WW_SEND_FEEDBACK, nil)] forState:UIControlStateNormal];
    
    [self.signUpButton wwStyleWhiteBorderedButton];
    [self.signUpButton setTitle:[NSString stringWithFormat:@" %@", NSLocalizedString(WW_SIGN_IN, nil)] forState:UIControlStateNormal];
    
    
    [self.inviteFriendsButton wwStyleWhiteBorderedButton];
    [self.inviteFriendsButton setTitle:[NSString stringWithFormat:@" %@", NSLocalizedString(WW_INVITE_FRIENDS, nil)] forState:UIControlStateNormal];*/
    
    /*self.notLoggedInMessage.font = WW_FONT_H6;
    self.notLoggedInMessage.textColor = WW_BLACK_FONT_COLOR;
    self.notLoggedInMessage.text = NSLocalizedString(WW_SIGN_IN_MESSAGE, nil);*/
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCurrentUserChanged:) name:WW_CURRENT_USER_UPDATED_NOTIFICATION object:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
    
    /*UIImage* img = [WWGradientView buildGradientView:self.view.bounds start:[UIColor blackColor] end:[UIColor uuColorFromHex:@"2C4952"]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:img];*/
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self refreshUi];
}

#pragma mark - Table callbacks

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.tableViewFirst)
        return self.tableDataFirst.count;
    else if(tableView == self.tableViewSecond)
        return self.tableDataSecond.count;
    
    return 0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellId;
    UIColor* backgroundColor;

    if(indexPath.row%2 == 1)
    {
        cellId = @"SelectionTableCellId";
        backgroundColor = [UIColor whiteColor];
    }
    else
    {
        cellId = @"SelectionTableCellIdx2";
        backgroundColor = WW_HEADER_BACKGROUND_COLOR;
    }
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.textLabel.textColor = WW_BLACK_FONT_COLOR;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.backgroundColor = backgroundColor;
        cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        cell.backgroundView.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        cell.selectedBackgroundView.backgroundColor = WW_GRAY_BACKGROUND;
        cell.textLabel.font = WW_FONT_H1;
    }
    NSDictionary* d = nil;
    
    if(tableView == self.tableViewFirst)
    {
        d = [self.tableDataFirst objectAtIndex:indexPath.row];
    }
    else if(tableView == self.tableViewSecond)
    {
        d = [self.tableDataSecond objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = d[@"name"];
    cell.imageView.image = [UIImage imageNamed:d[@"icon"]];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* d = [self.tableDataFirst objectAtIndex:indexPath.row];
    
    if(tableView == self.tableViewFirst)
    {
        [self deselectCellsInTableView:self.tableViewSecond];
        
        d = [self.tableDataFirst objectAtIndex:indexPath.row];
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
    else if(tableView == self.tableViewSecond)
    {
        [self deselectCellsInTableView:self.tableViewFirst];
        
        d = [self.tableDataSecond objectAtIndex:indexPath.row];
        switch ([d[@"id"] integerValue])
        {
            case WWUserProfileSignIn:
            {
                [self onSignUpClicked];
                break;
            }
            case WWUserProfileInviteFriends:
            {
                [self onInviteFriends];
                break;
            }
            case WWUserProfileSendFeedback:
            {
                [Flurry logEvent:WW_FLURRY_EVENT_TAP_FEEDBACK];
                [[NSNotificationCenter defaultCenter] postNotificationName:WW_SWITCH_TO_SENDFEEDBACK_CONTROLLER object:nil];
                break;
            }
                
            default:
                break;
        }
    }
}

#pragma mark - Private helpers

-(void)deselectCellsInTableView:(UITableView*)tableView
{
    for (int section = 0; section < [tableView numberOfSections]; section++)
    {
        for (int row = 0; row < [tableView numberOfRowsInSection:section]; row++)
        {
            NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:section];
            [tableView deselectRowAtIndexPath:cellPath animated:NO];
        }
    }
    
    [tableView reloadData];
}

- (void) refreshUi
{
    WWUser* user = [WWSettings currentUser];
    
    NSMutableArray* a = [NSMutableArray array];
    
    [a addObject:@{@"id":@(WWUserProfileActionFindPlaces), @"name": NSLocalizedString(WW_FIND_PLACES, nil), @"icon" : @"find_places" }];
    if (user)
    {
        [a addObject:@{@"id":@(WWUserProfileActionFavorites), @"name":NSLocalizedString(WW_FAVORITES, nil), @"icon" : @"favorites" }];
    }
    [a addObject:@{@"id":@(WWUserProfileActionSettings), @"name":NSLocalizedString(WW_SETTINGS, nil), @"icon" : @"settings" }];
    [a addObject:@{@"id":@(WWUserProfileActionTutorial), @"name":NSLocalizedString(WW_TUTORIAL, nil), @"icon" : @"tutorial" }];
    self.tableDataFirst = a;
    [self.tableViewFirst reloadData];
    
    
    NSMutableArray* b = [NSMutableArray array];
    if (user)
    {
        [b addObject:@{@"id":@(WWUserProfileInviteFriends), @"name":NSLocalizedString(WW_INVITE_FRIENDS, nil)}];
    }
    else
    {
        [b addObject:@{@"id":@(WWUserProfileSignIn), @"name":NSLocalizedString(WW_SIGN_IN, nil)}];
    }
    [b addObject:@{@"id":@(WWUserProfileSendFeedback), @"name": NSLocalizedString(WW_SEND_FEEDBACK, nil)}];
    self.tableDataSecond = b;
    [self.tableViewSecond reloadData];
}

#pragma mark - UI Event Handlers

- (void)onSignUpClicked
{
    [[NSNotificationCenter defaultCenter] postNotificationName:WW_SWITCH_TO_LOGIN_CONTROLLER object:nil];
}

- (void)onSignOutClicked:(id)sender
{
    [WWSettings setCurrentUser:nil];
    [self refreshUi];
}

- (void)onInviteFriends
{
    [Flurry logEvent:WW_FLURRY_EVENT_INVITE_FRIENDS];
    
    UIImage *shareImage = [UIImage imageNamed:@"logo.png"];
    NSArray* items = @[ WW_SHARE_SMS_BODY, shareImage];
    
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
