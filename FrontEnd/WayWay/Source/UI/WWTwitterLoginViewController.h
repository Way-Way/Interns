//
//  WWTwitterLoginViewController.h
//  WayWay
//
//  Created by Ryan DeVore on 8/7/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWTwitterLoginViewController : UIViewController

+ (void) loginToTwitter:(UIViewController*)parent
             completion:(void (^)(bool authSuccess, bool importSuccess, NSString* accessToken, NSString* accessSecret))completion;

@end
