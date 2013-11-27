//
//  CameraAppViewController.m
//  Camera App
//
//  Created by mo_r on 21/11/13.
//  Copyright (c) 2013 mo_r. All rights reserved.
//

#import "CameraAppViewController.h"

@interface CameraAppViewController ()

@end

@implementation CameraAppViewController


- (IBAction)takePhoto {
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)chooseExisting {
    picker2 = [[UIImagePickerController alloc] init];
    picker2.delegate = self;
    [picker2 setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:picker2 animated:YES completion:NULL];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    
    NSLog(@"X: %f   Y: %f", screenWidth, screenHeight);
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
  
    UIImage *bart = [UIImage imageNamed:@"bart.gif"];
    UIImage *steveJobs = [UIImage imageNamed:@"steveJobs.jpg"];
    
    UIGraphicsBeginImageContext(CGSizeMake(screenHeight, screenWidth));
    
    CGContextRef            context = UIGraphicsGetCurrentContext();
    
    [bart drawInRect:CGRectMake(0, screenWidth/4, screenHeight/2, screenWidth/2)];
    [steveJobs drawInRect: CGRectMake(screenHeight/2, screenWidth/4, screenHeight/2, screenWidth/2)];
    
    UIImage        *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [imageView setImage:smallImage];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.photoindex = 0;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
