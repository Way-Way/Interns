//
//  CameraAppViewController.h
//  Camera App
//
//  Created by mo_r on 21/11/13.
//  Copyright (c) 2013 mo_r. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraAppViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    UIImagePickerController *picker;
    UIImagePickerController *picker2;
    UIImage *image;
    UIImage *image2;
    IBOutlet UIImageView *singleImageView;
    IBOutlet UIImageView *imageView;
    IBOutlet UIImageView *imageView2;
}

@property (nonatomic) NSUInteger photoIndex;
@property (nonatomic) BOOL shareEnabled;
@property (strong, nonatomic) UIButton *camera2;
@property (strong, nonatomic) UIButton *photo2;

- (IBAction)takePhoto:(id)sender;
- (IBAction)chooseExisting:(id)sender;

@end
