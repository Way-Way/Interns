//
//  WWTwitterLoginViewController.m
//  WayWay
//
//  Created by Ryan DeVore on 8/7/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWTwitterLoginViewController()<UIWebViewDelegate>

@property (nonatomic, retain) UINavigationBar* navBar;
@property (nonatomic, retain) UIWebView* webView;
@property (nonatomic, retain) UIActivityIndicatorView* spinner;
@property (nonatomic, copy) void (^completionBlock)(bool authSuccess, bool importSuccess, NSString* accessToken, NSString* accessSecret);
@property (nonatomic, copy) NSString* accessToken;
@property (nonatomic, copy) NSString* accessSecret;
@property (assign) bool authSuccess;
@property (assign) bool importSuccess;

@end

@implementation WWTwitterLoginViewController

WWTwitterLoginViewController* theTwitterLoginController = nil;

+ (void) loginToTwitter:(UIViewController*)parent
             completion:(void (^)(bool authSuccess, bool importSuccess, NSString* accessToken, NSString* accessSecret))completion
{
	if (theTwitterLoginController)
	{
		theTwitterLoginController = nil;
	}
	
	theTwitterLoginController = [[WWTwitterLoginViewController alloc] init];
	theTwitterLoginController.completionBlock = completion;
    theTwitterLoginController.view.frame = parent.view.bounds;
	[parent presentViewController:theTwitterLoginController animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    CGFloat width = self.view.bounds.size.width;
    CGFloat navBarHeight = 44.0f;
    self.navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, width, navBarHeight)];
    
    UINavigationItem* item = [[UINavigationItem alloc] initWithTitle:@"Login"];
    
    UIBarButtonItem* b = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelClicked:)];
    item.rightBarButtonItem = b;
    
    [self.navBar pushNavigationItem:item animated:NO];
    
	[self.view addSubview:self.navBar];
    
	self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, navBarHeight, width, self.view.bounds.size.height - navBarHeight)];
	self.webView.delegate = self;
	[self.view addSubview:self.webView];
}

- (void) viewWillAppear:(BOOL)animated
{
	self.view.backgroundColor = [UIColor blackColor];
	self.webView.backgroundColor = [UIColor blackColor];
}

- (void) viewDidAppear:(BOOL)animated
{
	self.spinner = [[UIActivityIndicatorView alloc] init];
	self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
	self.spinner.backgroundColor = [UIColor clearColor];
	[self.view addSubview:self.spinner];
	self.spinner.hidden = YES;
    
    WWUser* user = [WWSettings currentUser];
    NSString* url = [NSString stringWithFormat:@"%@/users/%@/auth/twitter", WW_BASE_URL, user.identifier];
	NSURLRequest* urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
	[self.webView loadRequest:urlRequest];
    
	self.spinner.hidden = NO;
	self.spinner.frame = self.view.frame;
	self.spinner.center = self.view.center;
	[self.spinner startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[self.spinner stopAnimating];
	self.spinner.hidden = YES;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    WWDebugLog(@"url: %@", request.URL);

    WWUser* user = [WWSettings currentUser];
    
    NSString* callbackURL = [NSString stringWithFormat:@"%@users/%@/auth_finished/twitter", WW_BASE_URL, user.identifier];
    NSURL* url = request.URL;
	NSString* urlString = [url absoluteString];
    
    if ([urlString hasPrefix:callbackURL])
    {
        NSString* accessToken = [urlString uuFindQueryStringArg:@"access_token"];
        NSString* accessTokenSecret = [urlString uuFindQueryStringArg:@"access_token_secret"];
        BOOL success = (accessToken != nil && accessTokenSecret != nil);
        self.accessToken = accessToken;
        self.accessSecret = accessTokenSecret;
        self.authSuccess = success;
        
        if (success)
        {
            user.twitterAuthKey = accessToken;
            user.twitterAuthSecret = accessTokenSecret;
            [WWSettings setCurrentUser:user];
            
            [self storeAccountWithAccessToken:accessToken secret:accessTokenSecret];
        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:^
            {
                if (self.completionBlock)
                {
                    self.completionBlock(false, false, accessToken, accessTokenSecret);
                }
            }];
        }
        
        return NO;
    }
    
	return YES;
}

- (void) onCancelClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^
     {
         if (self.completionBlock)
         {
             self.completionBlock(false, false, nil, nil);
         }
     }];
}

- (void)storeAccountWithAccessToken:(NSString *)token secret:(NSString *)secret
{
    ACAccountStore* accountStore = [[ACAccountStore alloc] init];
    ACAccountCredential* credential = [[ACAccountCredential alloc] initWithOAuthToken:token tokenSecret:secret];
    ACAccountType* accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    ACAccount* newAccount = [[ACAccount alloc] initWithAccountType:accountType];
    newAccount.credential = credential;
    
    [accountStore saveAccount:newAccount withCompletionHandler:^(BOOL success, NSError *error)
    {
        bool importSuccess = success;
        
        if (!success)
        {
            if ([[error domain] isEqualToString:ACErrorDomain])
            {
                if ([error code] == ACErrorAccountAlreadyExists)
                {
                    importSuccess = true;
                }
            }
        }
        
        self.importSuccess = importSuccess;
        [self performSelectorOnMainThread:@selector(finish) withObject:nil waitUntilDone:NO];
     }];
}

- (void) finish
{
    [self dismissViewControllerAnimated:YES completion:^
     {
         if (self.completionBlock)
         {
             self.completionBlock(self.authSuccess, self.importSuccess, self.accessToken, self.accessSecret);
         }
     }];
}

@end
