//
//  TweetViewController.m
//  Tweet
//
//  Created by mo_r on 27/11/13.
//  Copyright (c) 2013 mo_r. All rights reserved.
//

#import "TweetViewController.h"
#import <Social/Social.h>

@interface TweetViewController ()

@end

@implementation TweetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tweet:(id)sender {
//    UIActionSheet *share = [[UIActionSheet alloc] initWithTitle:@"Sharing godness" delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:@"Tweet it!", nil];
//    
//    [share showInView:self.view];     //view with several action buttons: fb, twitter, etc...
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"@waywayapp This is a default tweet!"];
        if (![tweetSheet addImage:[UIImage imageNamed:@"steveJobs.jpg"]]) {
            NSLog(@"Unable to add the image!");
        }
        if (![tweetSheet addURL:[NSURL URLWithString:@"http://wayway.us/"]]){
            NSLog(@"Unable to add the URL!");
        }
        [self presentViewController:tweetSheet animated:YES completion:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Make sure you have a Twitter account and you are connected." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
//        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
//        [tweetSheet setInitialText:@"@wayway This is a default tweet!"];
//        [self presentViewController:tweetSheet animated:YES completion:nil];
//    } else {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Make sure you are connected on Twitter!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alertView show];
//    }
//}

@end
