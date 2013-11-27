//
//  ShareViewController.m
//  Share FB
//
//  Created by mo_r on 07/11/13.
//  Copyright (c) 2013 mo_r. All rights reserved.
//

#import "ShareViewController.h"


@implementation ShareViewController


- (IBAction)shareFb {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        slComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [slComposeViewController addImage:[UIImage imageNamed:@"steveJobs.jpg"]];
        [slComposeViewController addURL:[NSURL URLWithString:@"http://www.google.com"]];
        [self presentViewController:slComposeViewController animated:YES completion:NULL];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Facebook account" message:@"There are no facebook accounts configured." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [alert show];
        
    }
}

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


@end
