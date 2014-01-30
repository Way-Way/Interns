//
//  WWAppDelegate.m
//  WayWay
//
//  Created by Ryan DeVore on 5/17/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWAppDelegate () <WWListResultsDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate, UIAlertViewDelegate>

// Main Drawer Controller
@property (nonatomic, strong) MMDrawerController* rootDrawerController;

// Roots
@property (nonatomic, strong) WWHomeViewController* homeController;
@property (nonatomic, strong) WWLoginViewController* loginController;
@property (nonatomic, strong) WWSettingsViewController* settingsController;
@property (nonatomic, strong) WWFavoritesViewController* favoritesController;

// Root Nav Stacks
@property (nonatomic, strong) UINavigationController* homeNavController;
@property (nonatomic, strong) UINavigationController* loginNavController;
@property (nonatomic, strong) UINavigationController* settingsNavController;
@property (nonatomic, strong) UINavigationController* favoriteNavController;

// Left Drawer
@property (nonatomic, strong) WWUserProfileViewController* userProfileController;
@property (nonatomic, strong) WWIntroViewController* introViewController;

@end

@implementation WWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Crashlytics startWithAPIKey:@"563f72dff50e854f1884bec2c900146541f80cdd"];
    [Flurry startSession:@"CZ29GNW4CQP6FN75VVRC"];
    [GoogleConversionPing pingWithConversionId:@"968915130" label:@"ZX_nCJb-zwcQuvGBzgM" value:@"0" isRepeatable:NO];
    
    [UULocationManager startTracking];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSwitchToHomeControllerNotification:) name:WW_SWITCH_TO_HOME_CONTROLLER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSwitchToLoginControllerNotification:) name:WW_SWITCH_TO_LOGIN_CONTROLLER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSwitchToSettingsControllerNotification:) name:WW_SWITCH_TO_SETTINGS_CONTROLLER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSwitchToSendFeedbackControllerNotification:) name:WW_SWITCH_TO_SENDFEEDBACK_CONTROLLER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSwitchToFavoriteControllerNotification:) name:WW_SWITCH_TO_FAVORITES_CONTROLLER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOpenLeftDrawerNotification:) name:WW_OPEN_LEFT_DRAWER_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePushNewHomeViewNotification:) name:WW_PUSH_NEW_HOME_VIEW_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleViewPlaceInfoNotification:) name:WW_VIEW_PLACE_INFO_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleViewPhotoNotification:) name:WW_VIEW_PHOTO_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleViewPhotosByHashTagNotification:) name:WW_VIEW_PHOTOS_BY_HASH_TAG_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleViewIntroSlidesNotification:) name:WW_VIEW_INTRO_SLIDES_NOTIFICATION object:nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.homeController = [WWHomeViewController new];
    self.loginController = [WWLoginViewController new];
    self.settingsController = [WWSettingsViewController new];
    self.userProfileController = [WWUserProfileViewController new];
    self.favoritesController = [WWFavoritesViewController new];
    self.favoritesController.delegate = self;
    
    if ([UIScreen mainScreen].bounds.size.height == 480)
    {
        self.introViewController = [[WWIntroViewController alloc] initWithNibName:@"WWIntroViewController-35in" bundle:nil];
    }
    else
    {
        self.introViewController = [[WWIntroViewController alloc] initWithNibName:@"WWIntroViewController" bundle:nil];
    }
    
    WWHomeViewController* weakRef = self.homeController;
    self.introViewController.dismissCallback = ^(BOOL cancelled)
    {
        if (!cancelled)
        {
            weakRef.hasSetupMap = NO;
            [weakRef beginPlaceSearch];
        }
    };
    
    self.homeNavController = [[UINavigationController alloc] initWithRootViewController:self.homeController];
    self.loginNavController = [[UINavigationController alloc] initWithRootViewController:self.loginController];
    self.settingsNavController = [[UINavigationController alloc] initWithRootViewController:self.settingsController];
    self.favoriteNavController = [[UINavigationController alloc] initWithRootViewController:self.favoritesController];
    self.favoriteNavController.delegate = self;
    
    [self styleNavBar];

    self.rootDrawerController = [[MMDrawerController alloc] initWithCenterViewController:self.homeNavController leftDrawerViewController:self.userProfileController];
    self.rootDrawerController.maximumLeftDrawerWidth = 270;
    self.rootDrawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
    self.rootDrawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;

    self.window.rootViewController = self.rootDrawerController;

    [self checkLastLaunchTime];
    
    [self.window makeKeyAndVisible];
    
    if (![WWSettings hasSeenIntroSlides])
    {
        [self showIntroSlides];
        [WWSettings setHasSeenIntroSlides];
    }
    
    [[self class] registerForPushNotifications];
    [self checkRateItPopup];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self checkLastLaunchTime];
    [self cleanupCachedStorage];
    [self checkRateItPopup];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBSettings setDefaultAppID:@"243355059144499"];
    [FBAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
	return [[FBSession activeSession] handleOpenURL:url];
}

- (void) styleNavBar
{
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor whiteColor];
    shadow.shadowOffset = CGSizeMake(0, 1);
    
    NSDictionary* attrs =
    @{  NSForegroundColorAttributeName : WW_ORANGE_FONT_COLOR,
        NSFontAttributeName : [UIFont fontWithName:WW_DEFAULT_FONT_NAME size:17],
        NSShadowAttributeName : shadow
    };
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:attrs forState:UIControlStateNormal];
    
    [[UISegmentedControl appearance] setTintColor:WW_ORANGE_FONT_COLOR];
}

#pragma mark - Notification Handling

- (void) handleSwitchToHomeControllerNotification:(NSNotification*)notification
{
    [self changeCenterDrawer:self.homeNavController];
}

- (void) handleSwitchToLoginControllerNotification:(NSNotification*)notification
{
    [self.loginNavController popToRootViewControllerAnimated:NO];
    [self.rootDrawerController presentViewController:self.loginNavController animated:YES completion:nil];
}

- (void) handleSwitchToSettingsControllerNotification:(NSNotification*)notification
{
    [self changeCenterDrawer:self.settingsNavController];
}

-(void) handleSwitchToSendFeedbackControllerNotification:(NSNotification*)notification
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController* c = [[MFMailComposeViewController alloc] init];
        c.mailComposeDelegate = self;
        [c setSubject:WW_EMAIL_FEEDBACK_SUBJECT];
        [c setMessageBody:WW_EMAIL_FEEDBACK_BODY isHTML:YES];
        [c setToRecipients:@[WW_EMAIL_FEEDBACK_TO]];
        [self.rootDrawerController presentViewController:c animated:YES completion:nil];
    }
    else
    {
        [UIAlertView uuShowAlertWithTitle:@"" message:@"Mail is not set up on your device. Please contact us at feedback@wayway.us" buttonTitle:@"OK" completionHandler:nil];
    }
}

#pragma mark - Mail Delegates

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void) handleSwitchToFavoriteControllerNotification:(NSNotification*)notification
{
    [self changeCenterDrawer:self.favoriteNavController];
}

- (void) changeCenterDrawer:(UINavigationController*)navController
{
    if (self.rootDrawerController.centerViewController != navController)
    {
        [self.rootDrawerController setCenterViewController:navController withCloseAnimation:YES completion:nil];
    }
    else
    {
        [self.rootDrawerController closeDrawerAnimated:YES completion:nil];
    }
}

- (void) handleOpenLeftDrawerNotification:(NSNotification*)notification
{
    BOOL switchToHome = NO;
    if (notification.object)
    {
        switchToHome = [notification.object boolValue];
    }
    
    [self.rootDrawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished)
    {
        if (switchToHome)
        {
            self.rootDrawerController.centerViewController = self.homeNavController;
        }
    }];
}

- (void) handlePushNewHomeViewNotification:(NSNotification*)notification
{
    WWHomeViewController* c = [WWHomeViewController new];
    c.fixedSearchArgs = notification.object;
    [self.homeNavController pushViewController:c animated:YES];
}

- (void) handleViewPlaceInfoNotification:(NSNotification*)notification
{
    WWPlaceInfoViewController* c = [WWPlaceInfoViewController new];
    c.place = notification.object;
    c.place = [WWPlace cachedPlace:c.place.identifier];
    [self.homeNavController pushViewController:c animated:YES];
}

- (void) handleViewPhotoNotification:(NSNotification*)notification
{
    NSDictionary* d = notification.object;
    
    // Don't drill into a bad photo
    WWPhoto* photo = d[@"photo"];
    if (![WWSettings isBadPhoto:photo.identifier])
    {
        WWPhotoDetailsViewController* c = [WWPhotoDetailsViewController new];
        c.photo = photo;
        c.place = d[@"place"];
        c.photos = d[@"photos"];
        c.highlightedHashTag = d[@"hashtag"];
        c.currentFilter = [(NSNumber*)d[@"currentFilter"] intValue];
        WWPhotoDetailsAnimator *animator = [self transitionAnimator];
        animator.reverse = NO;
        NSValue *nsv = d[@"viewCenter"];
        animator.startPoint = nsv.CGPointValue;
        self.homeNavController.delegate = animator;
        [self.homeNavController pushViewController:c animated:YES];
    }
}

- (WWPhotoDetailsAnimator*)transitionAnimator {
    if (!transitionAnimator)
        transitionAnimator = [WWPhotoDetailsAnimator new];
    return transitionAnimator;
}

- (void) handleViewPhotosByHashTagNotification:(NSNotification*)notification
{
    NSDictionary* d = notification.object;
    
    WWPhotoHashTagViewController* c = [WWPhotoHashTagViewController new];
    c.hashTag = d[@"hashtag"];
    c.place = d[@"place"];
    [self.homeNavController pushViewController:c animated:YES];
}

- (void) handleViewIntroSlidesNotification:(NSNotification*)notification
{
    [self showIntroSlides];
    [self handleSwitchToHomeControllerNotification:notification];
}

#pragma mark - Launch Handling

//#define WW_SEARCH_RESET_THRESHOLD (1) // 1 seconds (for dev)
#define WW_SEARCH_RESET_THRESHOLD (24 * 60 * 60) // 1440 minutes (1 day)

- (void) checkLastLaunchTime
{
    NSDate* lastLaunch = [WWSettings lastLaunchTime];
    if (lastLaunch)
    {
        NSTimeInterval diff = [[NSDate date] timeIntervalSinceDate:lastLaunch];
        WWDebugLog(@"It has been %f seconds since the last user launch", diff);
        
        if (diff > WW_SEARCH_RESET_THRESHOLD)
        {
            WWDebugLog(@"App has not been launched in 15 minutes, clearing search args");
            WWSearchArgs* args = [WWSearchArgs new];
            [WWSettings saveCachedSearchArgs:args];
            [WWSettings setCurrentMapLocation:nil];
            [self.homeController beginPlaceSearch];
        }
    }
    
    [WWSettings updateLastLaunchTime:[NSDate date]];
}

- (void) cleanupCachedStorage
{
    // Purge expired content on a worker thread, if there is a lot to purge we don't
    // want to hold up the app startup sequence
    [UUDataCache uuSetCacheExpirationLength:(60 * 60 * 24 * 7)]; // 7 Days
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
    ^{
       [UUDataCache uuPurgeExpiredContent];
       
       // Purge content above 50k in size, which should be all large photos
       [UUDataCache uuPurgeContentAboveSize:50000];
    });
}

- (void) showHalfMapView:(WWPlace*)place
{
    WWHomeViewController* c = [WWHomeViewController new];
    c.forceLeftMenuAlways = YES;
    
    WWSearchArgs* args = [WWSettings cachedSearchArgs];
    args.autoCompleteArg = [NSString stringWithFormat:@"%@", place.identifier];
    args.lastAutoCompleteInput = place.name;
    args.autoCompleteType = @"place_id";
    args.locationName = nil;
    args.trendingOnly = nil;
    args.openRightNow = nil;
    args.priceOne = nil;
    args.priceTwo = nil;
    args.priceThree = nil;
    args.priceFour = nil;
    
    [WWSettings saveCachedSearchArgs:args];
    
    [self.favoriteNavController pushViewController:c animated:YES];
    [c onRefreshButtonTapped:nil];
    
    [self.homeController changeSelectedPlace:place];
    [self.homeController onRefreshButtonTapped:nil];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (navigationController == self.favoriteNavController &&
        [viewController isKindOfClass:[WWHomeViewController class]])
    {
        [self.rootDrawerController setCenterViewController:self.homeNavController withCloseAnimation:YES completion:nil];
        [self.favoriteNavController popToRootViewControllerAnimated:NO];
    }
}

- (void) showIntroSlides
{
    [self.introViewController resetIntro];
    [self.introViewController wwShowWithAlphaFadeInView:self.rootDrawerController.view];
    [self.introViewController viewWillAppear:NO];
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Push Notification Support
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

+ (void) registerForPushNotifications
{
    WWUser* user = [WWSettings currentUser];
    if (user != nil)
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    }
}

- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    WWDebugLog(@"PushNotification Device Token: %@", [deviceToken wwToHexString]);
    
    WWUser* user = [WWSettings currentUser];
    if (user != nil)
    {
        NSString* hexToken = [deviceToken wwToHexString];
        [[WWServer sharedInstance] uploadPushToken:user token:hexToken completion:nil];
    }
}

- (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    WWDebugLog(@"%@", error);
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    WWDebugLog(@"%@", userInfo);
}

- (void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    WWDebugLog(@"%@", notification);
}

#pragma mark - Rate It Popup

#define WW_RATE_IT_POPUP_TAG 5000

- (void) checkRateItPopup
{
    int appLaunchCount = [WWSettings appLaunchCount];
    [WWSettings incrementAppLaunchCount];
    
    // Don't prompt after 2nd app launch
    if (appLaunchCount <= 1)
    {
        return;
    }
    
    WWRateItPref rateItPref = [WWSettings rateItPref];
    
    // User has chosen to ignore forever, or has chosen to rate the app.
    if (rateItPref == WWRateItPrefIgnoreForever ||
        rateItPref == WWRateItPrefRatedIt)
    {
        return;
    }
    
    NSDate* lastRateItTime = [WWSettings lastRateItPopupTime];
    NSTimeInterval timeSinceLastPopup = [[NSDate date] timeIntervalSinceDate:lastRateItTime];
    
    // Popup has been presented within the last week, skip it for now.
    if (timeSinceLastPopup < kWWSecondsPerWeek)
    {
        return;
    }
    
    [WWSettings setLastRateItPopupTime:[NSDate date]];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Rate it"
                                                    message:@"Your feedback really matters to us! Please take a moment to rate us on iTunes."
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Rate It", @"Not now", @"Ignore Forever", nil];
    
    alert.tag = WW_RATE_IT_POPUP_TAG;
    [alert show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == WW_RATE_IT_POPUP_TAG)
    {
        switch (buttonIndex)
        {
            case 0: // Rate It
                [WWSettings updateRateItPref:WWRateItPrefRatedIt];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:WW_APP_STORE_URL]];
                break;
               
            default:
            case 1: // Ignore This Time
                [WWSettings updateRateItPref:WWRateItPrefIgnoreThisTime];
                break;
                
            case 2:
                [WWSettings updateRateItPref:WWRateItPrefIgnoreForever];
                break;
        }
    }
}

@end
