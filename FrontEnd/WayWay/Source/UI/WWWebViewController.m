//
//  WWWebViewController.m
//  WayWay
//
//  Created by Ryan DeVore on 7/24/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWWebViewController ()

@end

@implementation WWWebViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [self wwBackNavItem];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.titleView = [self wwCenterNavItem:self.navTitle];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlToLoad]];
    [self.webView loadRequest:request];
}

- (void) onDone
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
