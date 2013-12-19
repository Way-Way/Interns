//
//  CameraViewController.h
//  Camera App
//
//  Created by mo_r on 13/12/13.
//  Copyright (c) 2013 mo_r. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverlayView.h"

@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
@public
    UIImagePickerController *picker;
    UIImagePickerController *picker2;
}


@property (weak, nonatomic) UIButton *captureButton;
@property (weak, nonatomic) UIButton *cameraRevButton;
@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) UIImage *overViewImage;
@property (weak, nonatomic) NSMutableArray *photos;
@property (nonatomic) NSUInteger photoIndex;


@end
