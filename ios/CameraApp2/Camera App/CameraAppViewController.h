//
//  CameraAppViewController.h
//  Camera App
//
//  Created by mo_r on 21/11/13.
//  Copyright (c) 2013 mo_r. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraViewController.h"


@interface CameraAppViewController : UIViewController<CameraViewControllerDelegate> {

    @protected
    UIImage *image1;
    UIImage *image2;
    UIImage *image3;
    IBOutlet UIImageView *singleImageView;
    IBOutlet UIImageView *imageView;
    IBOutlet UIImageView *imageView2;
    IBOutlet UIImageView *imageView3;

    UIImage *imageTest;
    UIImageView *imageViewTest;
}

@property (nonatomic) NSUInteger photoIndex;
@property (nonatomic) BOOL shareEnabled;
@property (strong, nonatomic) UIButton *camera2;
@property (strong, nonatomic) UIButton *photo2;

@property (strong ,nonatomic) UIButton *twitterButton;
@property (strong, nonatomic) UIViewController *editPhotoController;

@property (strong, nonatomic) NSString *test;

//- (IBAction)takePicture:(id)sender;     //action of "take picture" button which is set progrmmatically
//- (IBAction)takePhoto:(id)sender;
//- (IBAction)chooseExisting:(id)sender;

@end
