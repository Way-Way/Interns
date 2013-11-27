//
//  ShareViewController.h
//  Share FB
//
//  Created by mo_r on 07/11/13.
//  Copyright (c) 2013 mo_r. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>

@interface ShareViewController : UIViewController {
    SLComposeViewController *slComposeViewController;
    UIImage *image;
}

- (IBAction)shareFb;

@end
