//
//  CameraAppViewController.m
//  Camera App
//
//  Created by mo_r on 21/11/13.
//  Copyright (c) 2013 mo_r. All rights reserved.
//

#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>

#import "CameraAppViewController.h"
#import "UIImageExtras.h"
#import "CameraViewController.h"

@interface CameraAppViewController ()

@end

@implementation CameraAppViewController

#define MASK_UNIT 33.5
#define PIXEL_UNIT 3
#define SCREEN_HEIGTH 480
#define SCREEN_WIDTH 320


- (IBAction)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toHomeView"]) {
            CameraViewController *vc = [segue destinationViewController];
            vc.photoIndex = self.photoIndex;
    }
}

- (IBAction)takePhoto:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    CameraViewController *cameraVc = [[CameraViewController alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:cameraVc animated:YES completion:nil];
}

//- (IBAction)chooseExisting:(id)sender {
//    if ([sender tag] == 0)
//        self.photoIndex = 0;
//    else if ([sender tag] == 1)
//        self.photoIndex = 1;
//    else
//        self.photoIndex = 2;
//    picker2 = [[UIImagePickerController alloc] init];
//    picker2.delegate = self;
//    [picker2 setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
//    [self presentViewController:picker2 animated:YES completion:NULL];
//}

- (void)previewPhoto
{

}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)combineImages {
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    UIGraphicsBeginImageContext(CGSizeMake(screenHeight * PIXEL_UNIT, screenWidth * PIXEL_UNIT));
    
    CGContextRef            context = UIGraphicsGetCurrentContext();
    
    UIImage *frame = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"photoFrame" ofType:@"png"]];
    if (frame == nil)
        NSLog(@"photoFrame.png not found");
    [image drawInRect:CGRectMake(0, 0, screenHeight * PIXEL_UNIT / 3, screenWidth * PIXEL_UNIT)];
    [image2 drawInRect: CGRectMake(screenHeight * PIXEL_UNIT / 3, 0, screenHeight * PIXEL_UNIT / 3, screenWidth * PIXEL_UNIT)];
    [image3 drawInRect:CGRectMake(2 * (screenHeight * PIXEL_UNIT / 3), 0, screenHeight * PIXEL_UNIT / 3, screenWidth * PIXEL_UNIT)];
    [frame drawInRect:CGRectMake(0, 0, (screenHeight * PIXEL_UNIT) , screenWidth * PIXEL_UNIT)];
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/combinedImg.jpg"];
    UIImage        *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [UIImageJPEGRepresentation(smallImage, 0) writeToFile:jpgPath atomically:YES];
}

- (IBAction)twitterShare:(id)sender {
    if (self.shareEnabled == YES) {
        [self combineImages];
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:@"@waywayapp Check out this app!"];
            
            NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
            NSString *docDirectory = [sysPaths objectAtIndex:0];
            NSString *filePath = [NSString stringWithFormat:@"%@/combinedImg.jpg", docDirectory];
            NSLog(@"%@", filePath);
            UIImage * savedImg = [[UIImage alloc] initWithContentsOfFile:filePath];
            
            if (![tweetSheet addImage:savedImg]) {
                NSLog(@"Unable to add the image!");
            }
            if (![tweetSheet addURL:[NSURL URLWithString:@"http://wayway.us/"]]){
                NSLog(@"Unable to add the URL!");
            }
            [self presentViewController:tweetSheet animated:YES completion:nil];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Make sure you have a Twitter account and you are connected." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"There is 0 photo." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (IBAction)facebookShare:(id)sender {
    if (self.shareEnabled == YES) {
//        NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
//        NSString *docDirectory = [sysPaths objectAtIndex:0];
//        NSString *filePath = [NSString stringWithFormat:@"%@/combinedImg.jpg", docDirectory];
//        UIImage * savedImg = [[UIImage alloc] initWithContentsOfFile:filePath];
        [self combineImages];
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            SLComposeViewController *fbSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            [fbSheet setInitialText:@"@waywayapp Check out this app!"];
            
            NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
            NSString *docDirectory = [sysPaths objectAtIndex:0];
            NSString *filePath = [NSString stringWithFormat:@"%@/combinedImg.jpg", docDirectory];
            UIImage * savedImg = [[UIImage alloc] initWithContentsOfFile:filePath];
            
            if (![fbSheet addImage:savedImg]) {
                NSLog(@"Unable to add the image!");
            }
            if (![fbSheet addURL:[NSURL URLWithString:@"http://wayway.us/"]]){
                NSLog(@"Unable to add the URL!");
            }
            [self presentViewController:fbSheet animated:YES completion:nil];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Make sure you have a Twitter account and you are connected." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"There is 0 photo." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];

    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.photoIndex = 0;
    self.shareEnabled = NO;
    
    NSLog(@"%@", self.test);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
