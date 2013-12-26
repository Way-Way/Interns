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

static int indexPhoto = 0;

@implementation CameraViewController

@synthesize picture, overViewImage;
@synthesize delegate = _delegate;

#define MASK_UNIT 33.5
#define PIXEL_UNIT 3
#define SCREEN_HEIGTH 480
#define SCREEN_WIDTH 320



//- (IBAction)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
////    if ([segue.identifier isEqualToString:@"toHomeView"]) {
////        CameraAppViewController *vc = [segue destinationViewController];
//    
////        vc.photoIndex = photoIndex;
////        if (vc.photoIndex == 2)
////            vc.photoIndex = 0;
////    }
//
////    [self.navigationController popViewControllerAnimated:YES];
//    [self.delegate done:@"This is a test"];
//}

- (IBAction)usePressed:(id)sender {
    if (indexPhoto > 2)
        indexPhoto = 0;
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    //        [image addObject:overViewImage];
    //        self.photos[photoIndex] = [self.photos[photoIndex] imageByScalingAndCroppingForSize:CGSizeMake(screenWidth * 4 - (MASK_UNIT * 8), screenHeight * 4)];
    //        [self takePhoto:nil];
    
    image = [overViewImage imageByScalingAndCroppingForSize:CGSizeMake(screenWidth * 4 - (MASK_UNIT * 8), screenHeight * 4)];
    [self.delegate done:image with:indexPhoto];
    indexPhoto++;

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

//- (IBAction)usePhoto:(id)sender {
//    if (indexPhoto < 2) {
//        CGRect screenBound = [[UIScreen mainScreen] bounds];
//        CGSize screenSize = screenBound.size;
//        CGFloat screenWidth = screenSize.width;
//        CGFloat screenHeight = screenSize.height;
//
//        image = [overViewImage imageByScalingAndCroppingForSize:CGSizeMake(screenWidth * 4 - (MASK_UNIT * 8), screenHeight * 4)];
//        indexPhoto++;
//    }
//    else
//        indexPhoto = 0;
//}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;

    overViewImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picture setImage:overViewImage];

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

    NSLog(@"%d", indexPhoto);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
