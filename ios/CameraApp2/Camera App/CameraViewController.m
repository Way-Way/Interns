//
//  CameraViewController.m
//  Camera App
//
//  Created by mo_r on 13/12/13.
//  Copyright (c) 2013 mo_r. All rights reserved.
//

#import "CameraViewController.h"
#import "CameraAppViewController.h"
#import "OverlayView.h"
#import "UIImageExtras.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

@synthesize picture, overViewImage, photoIndex;

#define MASK_UNIT 33.5
#define PIXEL_UNIT 3
#define SCREEN_HEIGTH 480
#define SCREEN_WIDTH 320


- (IBAction)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toHomeView"]) {
        CameraAppViewController *vc = [segue destinationViewController];
        
        vc.test = @"this is a test";
        vc.photoIndex = photoIndex;
        if (vc.photoIndex == 2)
            vc.photoIndex = 0;
        [picker dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)toHomeView:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toHomeView"]) {
        CameraAppViewController *vc = [segue destinationViewController];

        NSLog(@"%@", vc);
                vc.test = @"this is a test";
        NSLog(@"in if");
    }
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)reverseCamera:(id)sender {
    picker.cameraDevice == UIImagePickerControllerCameraDeviceFront?
    (picker.cameraDevice = UIImagePickerControllerCameraDeviceRear):
    (picker.cameraDevice = UIImagePickerControllerCameraDeviceFront);
}

- (IBAction)takePicture:(id)sender {
    [picker takePicture];
}

- (IBAction)takePhoto:(id)sender {
//    [self dismissViewControllerAnimated:NO completion:NULL];
   
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    picker.showsCameraControls = NO; //
    
    
    OverlayView *overlay = [[OverlayView alloc]
                                initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGTH)];
        
        [overlay cameraRevWithTarget:self action:@selector(reverseCamera:) controlEvents:UIControlEventTouchUpInside];
        [overlay captureWithTarget:self action:@selector(takePicture:) controlEvents:UIControlEventTouchUpInside];

    picker.cameraOverlayView = overlay;
    
    [self presentViewController:picker animated:NO completion:NULL];
}

- (IBAction)usePhoto:(id)sender {
    if (photoIndex < 1) {
        CGRect screenBound = [[UIScreen mainScreen] bounds];
        CGSize screenSize = screenBound.size;
        CGFloat screenWidth = screenSize.width;
        CGFloat screenHeight = screenSize.height;
        
        [self.photos addObject:overViewImage];
        self.photos[photoIndex] = [self.photos[photoIndex] imageByScalingAndCroppingForSize:CGSizeMake(screenWidth * 4 - (MASK_UNIT * 8), screenHeight * 4)];
        [self takePhoto:nil];
        
        photoIndex++;
    }
//    else {
////        [self.navigationController popToRootViewControllerAnimated:YES];
//        
//        UIViewController *dest = [[CameraAppViewController alloc] init];
//        UIViewController *src = self;
//        UIStoryboardSegue *storyBoard = [[UIStoryboardSegue alloc] initWithIdentifier:@"toHomeView" source:src destination:dest];
//
//        [self toHomeView:storyBoard sender:nil];
//    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;

    overViewImage = [info objectForKey:UIImagePickerControllerOriginalImage];
//    overViewImage = [overViewImage imageByScalingAndCroppingForSize:CGSizeMake(screenWidth * 4 - (MASK_UNIT * 8), screenHeight * 4)];
    [picture setImage:overViewImage];
//    self.shareEnabled = YES;
//    
//    if (self.photoIndex == 0) {
//        image = [info objectForKey:UIImagePickerControllerOriginalImage];
//        image = [image imageByScalingAndCroppingForSize:CGSizeMake(screenWidth * 4 - (MASK_UNIT * 8), screenHeight * 4)];
//        [imageView setImage:image];
//    }
//    else if (self.photoIndex == 1){
//        image2 = [info objectForKey:UIImagePickerControllerOriginalImage];
//        image2 = [image2 imageByScalingAndCroppingForSize:CGSizeMake(screenWidth * 4 - (MASK_UNIT * 8), screenHeight * 4)];
//        [imageView2 setImage:image2];
//    }
//    else {
//        image3 = [info objectForKey:UIImagePickerControllerOriginalImage];
//        image3 = [image3 imageByScalingAndCroppingForSize:CGSizeMake(screenWidth * 4 - (MASK_UNIT * 8), screenHeight * 4)];
//        [imageView3 setImage:image3];
//    }
//    if (self.photoIndex < 2) {
//        ++self.photoIndex;
//    } else {
//        self.photoIndex = 0;
//    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (IBAction)toRootView:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self takePhoto:nil];

    NSLog(@"%d", photoIndex);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
