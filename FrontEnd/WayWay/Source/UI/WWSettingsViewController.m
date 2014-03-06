//
//  WWSettingsViewController.m
//  WayWay
//
//  Created by Ryan DeVore on 7/24/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

typedef enum
{
    WWSettingsGroupSharing,
    WWSettingsGroupGeolocalization,
    WWSettingsGroupInfo,
    WWSettingsGroupLogout,
    WWSettingsGroupVersion,
    
} WWSettingsGroup;

typedef enum
{
    WWSettingsActionSharingFacebook,
    WWSettingsActionSharingTwitter,
    WWSettingsActionGeolocalization,
    WWSettingsActionAbout,
    WWSettingsActionTermsOfService,
    WWSettingsActionPrivacyPolicy,
    WWSettingsActionLogout,
    
} WWSettingsAction;

@interface WWSettingsViewController ()

@property (nonatomic, strong) NSMutableArray* tableData;
@property (assign) BOOL isLinkingToFacebook;
@property (assign) BOOL isLinkingToTwitter;

@end

@implementation WWSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void) buildTableData
{
    WWUser* user = [WWSettings currentUser];
    
    NSMutableArray* sharingItems = [NSMutableArray array];
    
    if (!user)
    {
        [sharingItems addObject:@{@"id":@(-1),   @"name":NSLocalizedString(WW_SETTINGS_LOGIN_TO_ENABLE_SHARING, nil) }];
    }
    else
    {
        if (user.hasPassword.boolValue) // Email account
        {
            [sharingItems addObject:@{@"id":@(WWSettingsActionSharingFacebook),   @"name":@"Facebook" }];
        }
        
        [sharingItems addObject:@{@"id":@(WWSettingsActionSharingTwitter),    @"name":@"Twitter" }];
    }
    
    NSArray* infoItems =
    @[
      @{@"id":@(WWSettingsActionAbout),             @"name":NSLocalizedString(WW_SETTINGS_ABOUT, nil) },
      @{@"id":@(WWSettingsActionTermsOfService),    @"name":NSLocalizedString(WW_SETTINGS_TERMS_OF_SERVICE, nil) },
      @{@"id":@(WWSettingsActionPrivacyPolicy),     @"name":NSLocalizedString(WW_SETTINGS_PRIVACY_POLICY, nil) },
      ];
    
    NSString* versionLabel = [NSString stringWithFormat:@"%@ build %@",
        [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"],
        [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    
    NSArray* logoutItems =
    @[
        @{@"id":@(WWSettingsActionLogout),
          @"name":NSLocalizedString(WW_SETTINGS_SIGN_OUT, nil)},
      ];
    
    self.tableData = [NSMutableArray array];
    [self.tableData addObject:@{@"id":@(WWSettingsGroupSharing), @"name":NSLocalizedString(WW_SETTINGS_SHARING, nil), @"items" : sharingItems, @"footerName" : @"" }];
    
    if ([WWSettings currentUser])
    {
        [self.tableData addObject:@{@"id":@(WWSettingsGroupInfo), @"name":@"", @"items" : infoItems, @"footerName" : @"" }];
        [self.tableData addObject:@{@"id":@(WWSettingsGroupLogout), @"name":@"", @"items" : logoutItems, @"footerName" : versionLabel }];
    }
    else
    {
        [self.tableData addObject:@{@"id":@(WWSettingsGroupInfo), @"name":@"", @"items" : infoItems, @"footerName" : versionLabel }];
    }
    
    self.navigationItem.leftBarButtonItem = [self wwMenuNavItem];
    self.navigationItem.titleView = [self wwCenterNavItem:@"Settings"];
    
    self.tableView.backgroundColor = WW_GRAY_COLOR_2;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshUi];
}

- (void) refreshUi
{
    [self buildTableData];
    [self.tableView reloadData];
}

/*- (BOOL) prefersStatusBarHidden
{
    return NO;
}*/

#pragma mark - Table callbacks

- (int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tableData.count;
}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary* d = self.tableData[section];
    NSArray* items = d[@"items"];
    return items.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSDictionary* d = self.tableData[section];
    NSString* title = d[@"name"];
    if (title.length > 0)
    {
        return 50;
    }
    else
    {
        return 10;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSDictionary* d = self.tableData[section];
    NSString* title = d[@"footerName"];
    if (title.length > 0)
    {
        return 35;
    }
    else
    {
        return 5;
    }
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 200, 30)];
    label.font = WW_FONT_H4;
    label.textColor = WW_GRAY_COLOR_7;
    label.textAlignment = NSTextAlignmentLeft;
    label.backgroundColor = [UIColor clearColor];
    
    NSDictionary* d = self.tableData[section];
    NSString* title = d[@"name"];
    label.text = title;
    
    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 50)];
    [v addSubview:label];
    return v;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 200, 30)];
    label.font = WW_FONT_H6;
    label.textColor = WW_GRAY_COLOR_7;
    label.textAlignment = NSTextAlignmentLeft;
    label.backgroundColor = [UIColor clearColor];
    
    NSDictionary* d = self.tableData[section];
    NSString* title = d[@"footerName"];
    label.text = title;
    
    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 50)];
    [v addSubview:label];
    return v;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* section = self.tableData[indexPath.section];
    NSArray* items = section[@"items"];
    NSDictionary* d = [items objectAtIndex:indexPath.row];
    
    NSString* cellId = @"SelectionTableCellId";
    if ([d[@"id"] integerValue] == WWSettingsActionLogout)
    {
        cellId = @"LogoutCellId";
    }
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = WW_FONT_H4;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([d[@"id"] integerValue] == WWSettingsActionLogout)
        {
            cell.textLabel.textColor = WW_LEAD_COLOR;
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
    }
    
    
    cell.textLabel.text = d[@"name"];
    
    WWUser* user = [WWSettings currentUser];
    
    switch ([d[@"id"] integerValue])
    {
        case WWSettingsActionSharingFacebook:
        {
            //self.facebookSwitch.on = [WWSettings isFacebookSharingOn];
            
            self.facebookSwitch.on = user && [user hasFacebookCredentials];
            
            if (self.isLinkingToFacebook)
            {
                UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                spinner.hidesWhenStopped = YES;
                [spinner startAnimating];
                cell.accessoryView = spinner;
            }
            else
            {
                cell.accessoryView = self.facebookSwitch;
            }
            
            break;
        }
            
        case WWSettingsActionSharingTwitter:
        {
            //self.twitterSwitch.on = [WWSettings isTwitterSharingOn];
            
            self.twitterSwitch.on = user && [user hasTwitterCredentials];
            
            if (self.isLinkingToTwitter)
            {
                UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                spinner.hidesWhenStopped = YES;
                [spinner startAnimating];
                cell.accessoryView = spinner;
            }
            else
            {
                cell.accessoryView = self.twitterSwitch;
            }
            break;
        }
            
        case WWSettingsActionGeolocalization:
        {
            self.geolocSwitch.on = [WWSettings isGeolocalizationOn];
            cell.accessoryView = self.geolocSwitch;
            break;
        }
            
        case WWSettingsActionPrivacyPolicy:
        case WWSettingsActionTermsOfService:
        case WWSettingsActionAbout:
        {
            UIImageView* imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chevron"]];
            cell.accessoryView = imgView;
            break;
        }
            
        default:
            cell.accessoryView = nil;
            break;
    }
    
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* section = self.tableData[indexPath.section];
    NSArray* items = section[@"items"];
    NSDictionary* d = [items objectAtIndex:indexPath.row];
    
    switch ([d[@"id"] integerValue])
    {
        case WWSettingsActionSharingFacebook:
        {
            [self onToggleFacebookClicked:nil];
            break;
        }
            
        case WWSettingsActionSharingTwitter:
        {
            [self onToggleTwitterClicked:nil];
            break;
        }
            
        case WWSettingsActionGeolocalization:
        {
            [self onToggleGeoLocClicked:nil];
            break;
        }
            
        case WWSettingsActionAbout:
        {
            [Flurry logEvent:WW_FLURRY_EVENT_TAP_ABOUT];
            [self showWebView:d[@"name"] fileName:@"About"];
            break;
        }
            
        case WWSettingsActionTermsOfService:
        {
            [Flurry logEvent:WW_FLURRY_EVENT_TAP_TERMS_AND_CONDITIONS];
            [self showWebView:d[@"name"] fileName:@"Terms"];
            break;
        }
            
        case WWSettingsActionPrivacyPolicy:
        {
            [Flurry logEvent:WW_FLURRY_EVENT_TAP_PRIVACY_POLICY];
            [self showWebView:d[@"name"] fileName:@"Privacy"];
            break;
        }
            
        case WWSettingsActionLogout:
        {
            [WWSettings setCurrentUser:nil];
            [self refreshUi];
            [[NSNotificationCenter defaultCenter] postNotificationName:WW_OPEN_LEFT_DRAWER_NOTIFICATION object:nil];
            break;
        }
            
        default:
            break;
    }
}

- (void) showWebView:(NSString*)title fileName:(NSString*)fileName
{
    NSURL* url = [[NSBundle mainBundle] URLForResource:fileName withExtension:@"html" subdirectory:[NSString stringWithFormat:@"Files/%@", fileName]];
    
    WWWebViewController* c = [[WWWebViewController alloc] initWithNibName:@"WWWebViewController" bundle:nil];
    c.navTitle = title;
    c.urlToLoad = [[url filePathURL] absoluteString];
    
    [self.navigationController pushViewController:c animated:YES];
}


- (IBAction)onToggleFacebookClicked:(id)sender
{
    /*
    BOOL val = [WWSettings isFacebookSharingOn];
    NSLog(@"facebook sharing: %d", val);
    [WWSettings toggleFacebookSharing:!val];
    [self.tableView reloadData];
    */
    
    [self onLinkToFacebookClicked:nil];
}

- (IBAction)onToggleTwitterClicked:(id)sender
{
    /*
    BOOL val = [WWSettings isTwitterSharingOn];
    [WWSettings toggleTwitterSharing:!val];
    [self.tableView reloadData];
     */
    
    [self onLinkToTwitterClicked:nil];
}

- (IBAction)onToggleGeoLocClicked:(id)sender
{
    BOOL val = [WWSettings isGeolocalizationOn];
    [WWSettings toggleGeolocalization:!val];
    [self.tableView reloadData];
}


- (IBAction)onLinkToFacebookClicked:(id)sender
{
    WWUser* user = [WWSettings currentUser];
    if ([user hasFacebookCredentials])
    {
        [self clearFacebookLink:user];
    }
    else
    {
        [self linkToFacebook:user];
    }
}

- (IBAction)onLinkToTwitterClicked:(id)sender
{
    WWUser* user = [WWSettings currentUser];
    if ([user hasTwitterCredentials])
    {
        [self clearTwitterLink:user];
    }
    else
    {
        [self linkToTwitter:user];
    }
}

- (void) clearFacebookLink:(WWUser*)user
{
    [[UIAlertView uuTwoButtonAlert:@""
                           message:@"Unlink Facebook Account?"
                         buttonOne:@"Yes"
                         buttonTwo:@"No"
                 completionHandler:^(NSInteger buttonIndex)
      {
          [self refreshUi];
          
          if (buttonIndex == 0)
          {
              self.isLinkingToFacebook = YES;
              [self refreshUi];
              [[WWServer sharedInstance] clearFacebookAuthForUser:user completionHandler:^(NSError *error, WWUser *updatedUser)
               {
                   WWDebugLog(@"User: %@", updatedUser);
                   
                   self.isLinkingToFacebook = NO;
                   [self refreshUi];
                   
                   /*
                   if (error)
                   {
                       [self hideProgress:@"Unable to clear Facebook credentials, please try again."];
                   }
                   else
                   {
                       [self hideProgress:@"Facebook credentials cleared"];
                   }*/
               }];
          }
      }] show];
}

- (void) clearTwitterLink:(WWUser*)user
{
    [[UIAlertView uuTwoButtonAlert:@""
                           message:@"Unlink Twitter Account?"
                         buttonOne:@"Yes"
                         buttonTwo:@"No"
                 completionHandler:^(NSInteger buttonIndex)
      {
          [self refreshUi];
          
          if (buttonIndex == 0)
          {
              self.isLinkingToTwitter = YES;
              [self refreshUi];
              [[WWServer sharedInstance] clearTwitterAuthForUser:user completionHandler:^(NSError *error, WWUser *updatedUser)
               {
                   WWDebugLog(@"User: %@", updatedUser);
                   
                   self.isLinkingToTwitter = NO;
                   [self refreshUi];
                   
                   /*
                   if (error)
                   {
                       [self hideProgress:@"Unable to clear Twitter credentials, please try again."];
                   }
                   else
                   {
                       [self hideProgress:@"Twitter credentials cleared"];
                   }*/
               }];
          }
      }] show];
}

- (void) linkToTwitter:(WWUser*)user
{
    self.isLinkingToTwitter = YES;
    [self refreshUi];
    [WWTwitterLoginViewController loginToTwitter:self completion:^(bool authSuccess, bool importSuccess, NSString *accessToken, NSString *accessSecret)
     {
         WWDebugLog(@"Link to twitter, authSuccess: %d, importSuccess: %d, accessToken: %@, accessSecret: %@", authSuccess, importSuccess, accessToken, accessSecret);
         
         self.isLinkingToTwitter = NO;
         [self refreshUi];
         
         /*
         if (!authSuccess)
         {
             [self hideProgress:@"Unable to link to Twitter, please try again."];
         }
         else if (!importSuccess)
         {
             [self hideProgress:@"Import Twitter credentials failed. check phone settings."];
         }
         else
         {
             [self hideProgress:@"Twitter account linked."];
         }*/
     }];
}

- (void) linkToFacebook:(WWUser*)user
{
    //[self showProgress:@"Linking account"];
    self.isLinkingToFacebook = YES;
    [self refreshUi];
    [FBSession openActiveSessionWithPublishPermissions:nil
                                       defaultAudience:FBSessionDefaultAudienceEveryone
                                          allowLoginUI:YES
                                     completionHandler:^(FBSession *session, FBSessionState status, NSError *error)
     {
         WWDebugLog(@"FB access token: %@", session.accessTokenData.accessToken);
         
         if (!error)
         {
             [[WWServer sharedInstance] user:user
                         linkFacebookAccount:session.accessTokenData.accessToken
                       accessTokenExpiration:session.accessTokenData.expirationDate
                           completionHandler:^(NSError *error, WWUser *updatedUser)
              {
                  self.isLinkingToFacebook = NO;
                  [self refreshUi];
                  
                  WWDebugLog(@"User: %@", updatedUser);
                  
                  /*
                  if (error)
                  {
                      [self hideProgress:@"Unable to link to Facebook, please try again."];
                  }
                  else
                  {
                      [self hideProgress:@"Facebook account linked."];
                  }*/
              }];
         }
         else
         {
             WWDebugLog(@"Facebook Auth Error: %@", error);
             //[self hideProgress:@"Unable to link to Facebook, please try again."];
             
             self.isLinkingToFacebook = NO;
             [self refreshUi];
         }
     }];
}


@end
