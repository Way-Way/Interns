//
//  WWPlaceInfoViewController.m
//  WayWay
//
//  Created by Ryan DeVore on 10/17/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

typedef enum
{
    WWPlaceInfoActionNone,
    
    WWPlaceInfoActionMap,
    WWPlaceInfoActionCall,
    WWPlaceInfoActionMenu,
    
    WWPlaceInfoActionAddToFavorites,
    
    WWPlaceInfoActionShareFacebook,
    WWPlaceInfoActionShareTwitter,
    WWPlaceInfoActionShareTextMessage,
    
} WWPlaceInfoAction;

typedef enum
{
    WWPlaceInfoSectionDetails,
    WWPlaceInfoSectionAddToFavorites,
    WWPlaceInfoSectionShare,
    WWPlaceInfoSectionHours,
    
} WWPlaceInfoSection;

#import "WWInclude.h"

@interface WWPlaceInfoViewController () <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray* tableData;
@property (nonatomic, strong) UIView* headerView;
@property (assign) BOOL isUpdatingFavorite;

@end

@implementation WWPlaceInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [self wwBackNavItem];
    self.navigationItem.titleView = [self wwCenterNavItem:@"Details"];
    self.isUpdatingFavorite = NO;
}

- (void) buildTableData
{
    NSMutableArray* sections = [NSMutableArray array];
    
    NSMutableArray* list = [NSMutableArray array];
    
    NSString* label = [self.place formattedAddressAndCity];
    if (label)
    {
        [list addObject:@{@"label" : label, @"icon" : @"map", @"action" : @(WWPlaceInfoActionMap) }];
    }
    
    label = [self.place formattedPhoneNumber];
    if (label)
    {
        [list addObject:@{@"label" : label, @"icon" : @"telephone", @"action" : @(WWPlaceInfoActionCall) }];
    }
    
    if (self.place.hasMenu)
    {
        // Hide Menu for v2.0 Launch
        //[list addObject:@{@"label" : @"Menu", @"icon" : @"restaurant_menu", @"action" : @(WWPlaceInfoActionMenu) }];
    }
    
    [sections addObject:list.copy];
    
    list = [NSMutableArray array];
    [list addObject:[self favoritesInfo]];
    [sections addObject:list.copy];
    
    list = [NSMutableArray array];
    [list addObject:@{@"label" : @"Facebook", @"icon" : @"share_facebook", @"action" : @(WWPlaceInfoActionShareFacebook) }];
    [list addObject:@{@"label" : @"Twitter", @"icon" : @"share_twitter", @"action" : @(WWPlaceInfoActionShareTwitter) }];
    [list addObject:@{@"label" : @"Text Message", @"icon" : @"share_text", @"action" : @(WWPlaceInfoActionShareTextMessage) }];
    [sections addObject:list.copy];
    
    if (self.place.hoursOfOperation && self.place.hoursOfOperation.count > 0)
    {
        list = [NSMutableArray array];
        
        for (NSDictionary* d in self.place.hoursOfOperation)
        {
            [list addObject:d];
        }
        
        [sections addObject:list.copy];
    }
    
    self.tableData = sections;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    
    self.headerView = [self buildHeaderLabel];
    [self buildTableData];
    [self.tableView reloadData];
}

- (void) wwOnPlaceShareTapped
{
    NSMutableArray* activityItems = [NSMutableArray array];
    [activityItems addObject:[self formatSharingBody]];
    
    UIActivityViewController* c = [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                                                    applicationActivities:nil];
    
    [self.navigationController presentViewController:c animated:YES completion:nil];
}

#pragma mark - Table View

- (int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tableData.count;
}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray* data = self.tableData[section];
    return data.count;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case WWPlaceInfoSectionDetails:
            return self.headerView;
            
        case WWPlaceInfoSectionAddToFavorites:
            return nil;
            
        case WWPlaceInfoSectionShare:
        {
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 200, 30)];
            label.font = WW_FONT_H5;
            label.textColor = WW_LIGHT_GRAY_FONT_COLOR;
            label.textAlignment = NSTextAlignmentLeft;
            label.backgroundColor = [UIColor clearColor];
            label.text = @"SHARE";
            
            UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 50)];
            [v addSubview:label];
            return v;
        }
            
        case WWPlaceInfoSectionHours:
        {
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 200, 30)];
            label.font = WW_FONT_H5;
            label.textColor = WW_LIGHT_GRAY_FONT_COLOR;
            label.textAlignment = NSTextAlignmentLeft;
            label.backgroundColor = [UIColor clearColor];
            label.text = @"HOURS";
            
            UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 50)];
            [v addSubview:label];
            return v;
        }
            
        default:
            return nil;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case WWPlaceInfoSectionDetails:
            return self.headerView.bounds.size.height;
            
        case WWPlaceInfoSectionAddToFavorites:
            return 10;
            
        case WWPlaceInfoSectionShare:
        case WWPlaceInfoSectionHours:
            return 50;
            
        default:
            return 0;
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* data = self.tableData[indexPath.section];
    NSDictionary* d = data[indexPath.row];
    
    switch (indexPath.section)
    {
        case WWPlaceInfoSectionDetails:
        {
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"WWPlaceInfoCellId"];
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WWPlaceInfoCellId"];
                cell.textLabel.font = WW_FONT_H4;
                
                UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chevron"]];
                cell.accessoryView = img;
            }
            
            cell.textLabel.text = d[@"label"];
            cell.imageView.image = [UIImage imageNamed:d[@"icon"]];
            return cell;
        }
            
        case WWPlaceInfoSectionAddToFavorites:
        {
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"WWPlaceInfoFavoriteCellId"];
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WWPlaceInfoFavoriteCellId"];
                cell.textLabel.font = WW_FONT_H4;
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                
                UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                spinner.hidesWhenStopped = YES;
                cell.accessoryView = spinner;
            }
            
            cell.textLabel.text = d[@"label"];
            cell.imageView.image = [UIImage imageNamed:d[@"icon"]];
            
            UIActivityIndicatorView* spinner = (UIActivityIndicatorView*)cell.accessoryView;
            
            if (self.isUpdatingFavorite)
            {
                [spinner startAnimating];
            }
            else
            {
                [spinner stopAnimating];
            }
            
            return cell;
        }
            
        case WWPlaceInfoSectionShare:
        {
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"WWPlaceInfoShareCellId"];
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WWPlaceInfoShareCellId"];
                cell.textLabel.font = WW_FONT_H4;
            }
            
            cell.textLabel.text = d[@"label"];
            cell.imageView.image = [UIImage imageNamed:d[@"icon"]];
            return cell;
        }
            
        case WWPlaceInfoSectionHours:
        {
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"WWPlaceInfoHoursCellId"];
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"WWPlaceInfoHoursCellId"];
                cell.textLabel.font = WW_FONT_H4;
                cell.detailTextLabel.font = WW_FONT_H4;
                cell.detailTextLabel.numberOfLines = 0;
                
                cell.textLabel.textColor = WW_LIGHT_GRAY_FONT_COLOR;
                cell.detailTextLabel.textColor = [UIColor blackColor];
            }
            
            cell.textLabel.text = d[@"day"];
            cell.detailTextLabel.text = d[@"hours"];
            return cell;
        }
            
        default:
            return nil;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray* data = self.tableData[indexPath.section];
    NSDictionary* d = data[indexPath.row];
    
    switch ([d[@"action"] integerValue])
    {
        case WWPlaceInfoActionMap:
        {
            [self onDirectionsClicked];
            break;
        }
            
        case WWPlaceInfoActionCall:
        {
            [self onCallClicked];
            break;
        }
            
        case WWPlaceInfoActionMenu:
        {
            [self onMenuClicked];
            break;
        }
            
        case WWPlaceInfoActionAddToFavorites:
        {
            [self onFavoritesButtonClicked];
            break;
        }
        
        case WWPlaceInfoActionShareFacebook:
        {
            [Flurry logEvent:WW_FLURRY_EVENT_TAP_SHARE_FACEBOOK];
            [self onFacebookShareClicked];
            break;
        }
            
        case WWPlaceInfoActionShareTwitter:
        {
            [Flurry logEvent:WW_FLURRY_EVENT_TAP_SHARE_TWITTER];
            [self onTwitterShareClicked];
            break;
        }
            
        case WWPlaceInfoActionShareTextMessage:
        {
            [Flurry logEvent:WW_FLURRY_EVENT_TAP_SHARE_TEXT];
            [self onSMSShareClicked];
            break;
        }
            
        default:
            break;
    }
}

- (void)onCallClicked
{
    [UIAlertView uuShowOKCancelAlert:@"" message:[NSString stringWithFormat:@"Call %@", [self.place formattedPhoneNumber]]
                   completionHandler:^(NSInteger buttonIndex)
     {
         if (buttonIndex == 1)
         {
             NSURL* phoneUrl = [NSURL URLWithString:[@"tel:" stringByAppendingString:self.place.phoneNumber]];
             [[UIApplication sharedApplication] openURL:phoneUrl];
             
             NSDictionary* d = @{@"PlaceId":self.place.identifier};
             [Flurry logEvent:WW_FLURRY_EVENT_TAP_CALL_PLACE withParameters:d];
         }
     }];
}

- (void)onMenuClicked
{
    WWMenuViewController* menuController = [[WWMenuViewController alloc] initWithNibName:@"WWMenuViewController" bundle:nil];
    menuController.place = self.place;
    [self.navigationController pushViewController:menuController animated:YES];
    
    //NSDictionary* d = @{@"PlaceId":self.place.identifier};
    //[Flurry logEvent:WW_FLURRY_EVENT_VIEW_MENU withParameters:d];
}

- (void)onReservationsClicked
{
    WWWebViewController* c = [[WWWebViewController alloc] initWithNibName:@"WWWebViewController" bundle:nil];
    c.navTitle = self.place.name;
    c.urlToLoad = self.place.reservationUrl;
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:c];
    [self presentViewController:nav animated:YES completion:nil];
    
    //NSDictionary* d = @{@"PlaceId":self.place.identifier};
    //[Flurry logEvent:WW_FLURRY_EVENT_VIEW_RESERVATIONS withParameters:d];
}

- (void)onDirectionsClicked
{
    NSDictionary* d = @{@"PlaceId":self.place.identifier};
    [Flurry logEvent:WW_FLURRY_EVENT_TAP_DIRECTIONS withParameters:d];
    
    NSString *latlong = [NSString stringWithFormat:@"%f,%f", self.place.latitude.doubleValue, self.place.longitude.doubleValue];
    NSString *url = [NSString stringWithFormat: @"http://maps.apple.com/?ll=%@&daddr=%@&q=%@",
                     [latlong stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                     [self.place.address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                     [self.place.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (UIView*) buildHeaderLabel
{
    UIColor* baseColor = WW_LIGHT_GRAY_FONT_COLOR;
    UIColor* blackColor = [UIColor blackColor];
    
    NSMutableParagraphStyle* ps = [[NSMutableParagraphStyle alloc] init];
    [ps setLineHeightMultiple:1.5];
    
    NSDictionary* baseAttrs = @{NSFontAttributeName : WW_FONT_H6, NSForegroundColorAttributeName : baseColor, NSParagraphStyleAttributeName:ps };
    NSDictionary* blackAttrs = @{NSFontAttributeName : WW_FONT_H6, NSForegroundColorAttributeName : blackColor, NSParagraphStyleAttributeName:ps };
    NSDictionary* boldAttrs = @{NSFontAttributeName : WW_FONT_H3, NSForegroundColorAttributeName : blackColor, NSParagraphStyleAttributeName:ps };
    
    NSMutableArray* parts = [NSMutableArray array];
    [parts addObject:self.place.name];
    
    if (self.place.combinedCategories && self.place.combinedCategories.length > 0)
    {
        [parts addObject:self.place.combinedCategories];
    }
    
    [parts addObject:@"$$$$"];
    
    NSString* text = [parts componentsJoinedByString:@"\n"];
    
    NSMutableAttributedString* as = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
    [as setAttributes:baseAttrs range:NSMakeRange(0, as.string.length)];
    [as setAttributes:blackAttrs range:[text rangeOfString:self.place.price]];
    [as setAttributes:boldAttrs range:[text rangeOfString:self.place.name]];
    
    CGFloat vSpace = 10;
    CGFloat hSpace = 20;
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(hSpace, vSpace, self.view.bounds.size.width - (hSpace*2), 100)];
    label.attributedText = as;
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    
    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, label.bounds.size.height)];
    v.backgroundColor = [UIColor clearColor];
    [v addSubview:label];
    [label sizeToFit];
    
    CGRect f = v.frame;
    f.size.height = label.bounds.size.height + (vSpace*2);
    v.frame = f;
    
    return v;
}

#pragma mark - Sharing

- (NSString*) formatSharingBody
{
    NSString* placeLink = [NSString stringWithFormat:@"http://www.wayway.us/place.html?%@", self.place.identifier];
    if (![[NSString stringWithFormat:@""] isEqualToString:self.place.shortName] && self.place.shortName != NULL)
    {
        placeLink = [NSString stringWithFormat:@"http://www.wayway.us/place.html?%@", self.place.shortName];
    }
    
    NSString* msg = [NSString stringWithFormat:
                     @"%@\n%@\n%@",
                     self.place.name,
                     self.place.address,
                     placeLink];
    
    return msg;
}

- (void)onEmailShareClicked
{
    if ([MFMailComposeViewController canSendMail])
    {
        NSString* subject = [NSString stringWithFormat:@"Check-out %@ on Way Way", self.place.name];
        
        MFMailComposeViewController* c = [[MFMailComposeViewController alloc] init];
        c.mailComposeDelegate = self;
        [c setSubject:subject];
        [c setMessageBody:[self formatSharingBody] isHTML:YES];
        [self presentViewController:c animated:YES completion:nil];
    }
    else
    {
        [UIAlertView uuShowAlertWithTitle:@"" message:@"Unable to send email, please check your phone mail settings and try again" buttonTitle:@"OK" completionHandler:nil];
    }
}

- (void)onSMSShareClicked
{
    if ([MFMessageComposeViewController canSendText])
    {
        MFMessageComposeViewController* c = [[MFMessageComposeViewController alloc] init];
        c.messageComposeDelegate = self;
        [c setBody:[self formatSharingBody]];
        [self presentViewController:c animated:YES completion:nil];
    }
    else
    {
        [UIAlertView uuShowAlertWithTitle:@"" message:@"Unable to send text, please check your phone settings and try again" buttonTitle:@"OK" completionHandler:nil];
    }
}

- (void)onTwitterShareClicked
{
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        NSString* placeLink = [NSString stringWithFormat:@"http://www.wayway.us/place.html?%@", self.place.identifier];
        /*if (![[NSString stringWithFormat:@""] isEqualToString:self.place.shortName] && self.place.shortName != NULL)
        {
            placeLink = [NSString stringWithFormat:@"http://www.wayway.us/place.html?%@", self.place.shortName];
        }*/
        
        NSString* text = [NSString stringWithFormat:@"@waywayapp Check out this place %@ : %@", self.place.name, placeLink];
        
        SLComposeViewController *tweet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweet setInitialText:text];
        
        if (![tweet addImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.place.bannerUrl]]]])
        {
            NSLog(@"Unable to add the image!");
        }
        if (![tweet addURL:[NSURL URLWithString:@"http://wayway.us/"]])
        {
            NSLog(@"Unable to add the URL!");
        }
        tweet.completionHandler = ^(SLComposeViewControllerResult result)
        {
            if (result == SLComposeViewControllerResultDone)
            {
                NSDictionary* d = @{ @"PlaceId":self.place.identifier };
                [Flurry logEvent:WW_FLURRY_EVENT_SHARE_TWITTER withParameters:d];
            }
            
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        
        [self presentViewController:tweet
                           animated:YES
                         completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                            message:@"Make sure you have a Twitter account and you are connected."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)onFacebookShareClicked
{
    
    NSString* placeLink = [NSString stringWithFormat:@"http://www.wayway.us/place.html?%@", self.place.identifier];
    if (![[NSString stringWithFormat:@""] isEqualToString:self.place.shortName] && self.place.shortName != NULL)
    {
        placeLink = [NSString stringWithFormat:@"http://www.wayway.us/place.html?%@", self.place.shortName];
    }
    
    FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
    
    params.link = [NSURL URLWithString:placeLink];
    params.picture = [NSURL URLWithString:self.place.bannerUrl];
    params.name = [[self.place.name stringByAppendingString:@" - "] stringByAppendingString:self.place.formattedAddressAndCity];
    
    NSNumber* score = self.place.classicRank;
    NSString* description = [@"This place has a Way Way score of " stringByAppendingString:[NSString stringWithFormat:@"%.2f",score.doubleValue]];
    description = [description stringByAppendingString:@"/10"];
    params.description = description;
    
    params.caption = @"Download Way Way at http://www.wayway.us";
    
    //When matching done
    //params.place = facebook_id;
    
    [FBDialogs presentShareDialogWithParams:params
                                clientState:Nil
                                    handler:
     ^(FBAppCall *call, NSDictionary *results, NSError *error) {
         if (error)
         {
             NSLog(@"Error: %@", error.description);
         }
         else
         {
             if (results[@"completionGesture"] &&
                 [results[@"completionGesture"] isEqualToString:@"cancel"])
             {
                 NSLog(@"User canceled story publishing");
             }
             else
             {
                 NSLog(@"Success: %@", results);
                 
                 NSDictionary* d = @{ @"PlaceId":self.place.identifier };
                 [Flurry logEvent:WW_FLURRY_EVENT_SHARE_FACEBOOK withParameters:d];
             }
         }
     }];
}

#pragma mark - Mail & Message Delegates

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result == MFMailComposeResultSent)
    {
        NSDictionary* d = @{ @"PlaceId":self.place.identifier };
        [Flurry logEvent:WW_FLURRY_EVENT_SHARE_EMAIL withParameters:d];
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    if (result == MessageComposeResultSent)
    {
        NSDictionary* d = @{ @"PlaceId":self.place.identifier };
        [Flurry logEvent:WW_FLURRY_EVENT_SHARE_TEXT withParameters:d];
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Favorites

- (NSDictionary*) favoritesInfo
{
    if (self.isUpdatingFavorite)
    {
        return @{@"label" : NSLocalizedString(WW_INFO_UPDATING_FAVORITES, nil), @"icon" : @"favorite_star_off", @"action" : @(-1) };
    }
    
    WWUser* user = [WWSettings currentUser];
    
    NSDictionary* d = [NSDictionary dictionary];
    
    if (user != nil)
    {
        if (self.place.isFavorite.boolValue)
        {
            d = @{@"label" : NSLocalizedString(WW_INFO_REMOVE_FAVORITES, nil), @"icon" : @"favorite_star_on", @"action" : @(WWPlaceInfoActionAddToFavorites) };
        }
        else
        {
            d = @{@"label" : NSLocalizedString(WW_INFO_ADD_FAVORITES, nil), @"icon" : @"favorite_star_off", @"action" : @(WWPlaceInfoActionAddToFavorites) };
        }
    }
    else
    {
        d = @{@"label" : NSLocalizedString(WW_INFO_ADD_FAVORITES, nil), @"icon" : @"favorite_star_off", @"action" : @(WWPlaceInfoActionAddToFavorites) };
    }
        
    return d.copy;
}

- (void) updateFavoriteButton
{
    NSDictionary* d = [self favoritesInfo];
    self.tableData[WWPlaceInfoSectionAddToFavorites] = @[d];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:WWPlaceInfoSectionAddToFavorites]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)onFavoritesButtonClicked
{
    WWUser* user = [WWSettings currentUser];
    
    if (user != nil)
    {
        self.place.isFavorite = @(!self.place.isFavorite.boolValue);
        
        if (self.isUpdatingFavorite)
        {
            WWDebugLog(@"Waiting on a favorite update, let's not spam the server");
            return;
        }
        
        NSDictionary* d = @{@"PlaceId":self.place.identifier,@"IsFavorite": self.place.isFavorite.boolValue ? @"true" : @"false" };
        [Flurry logEvent:WW_FLURRY_EVENT_TAP_ADD_TO_FAVORITES withParameters:d];
        
        self.isUpdatingFavorite = YES;
        [self updateFavoriteButton];
        [[WWServer sharedInstance] user:user
                         updateFavorite:self.place
                             completion:^(NSError *error)
         {
             self.isUpdatingFavorite = NO;
             [self updateFavoriteButton];
         }];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:WW_SWITCH_TO_LOGIN_CONTROLLER object:nil];
    }
}

@end
