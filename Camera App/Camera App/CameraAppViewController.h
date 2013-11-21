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
    IBOutlet UIImageView *imageView;
}

- (IBAction)takePhoto;
- (IBAction)chooseExisting;

@end
