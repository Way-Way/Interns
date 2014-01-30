//
//  WWWebViewController.h
//  WayWay
//
//  Created by Ryan DeVore on 7/24/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWWebViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) NSString* urlToLoad;
@property (nonatomic, strong) NSString* navTitle;

@end
