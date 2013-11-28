//
//  CameraAppViewController.m
//  Camera App
//
//  Created by mo_r on 21/11/13.
//  Copyright (c) 2013 mo_r. All rights reserved.
//

#import "CameraAppViewController.h"
#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>

@interface CameraAppViewController ()

@end

@implementation CameraAppViewController


- (IBAction)takePhoto:(id)sender {
    NSLog(@"clicked on %@ %ld", [sender currentTitle], (long)[sender tag]);
    [sender tag] == 0 ? (self.photoIndex = 0) : (self.photoIndex = 1);
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    
    UIView *mask = [[UIView alloc] init];

    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mask.png"]];
    imageview.frame = CGRectMake(0, 40, 320, 367);    //40px top, 73px bot
                                                      //33.5
    [mask addSubview:imageview];
    [mask bringSubviewToFront:imageview];
    
    
    picker.cameraOverlayView = mask;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)chooseExisting:(id)sender {
    NSLog(@"clicked on %@ %ld", [sender currentTitle], (long)[sender tag]);
    [sender tag] == 0 ? (self.photoIndex = 0) : (self.photoIndex = 1);
    picker2 = [[UIImagePickerController alloc] init];
    picker2.delegate = self;
    [picker2 setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:picker2 animated:YES completion:NULL];
}

#define MASK_UNIT 33.5

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    self.shareEnabled = YES;
    self.photoIndex == 0 ?  (image = [info objectForKey:UIImagePickerControllerOriginalImage]) :
                            (image2 = [info objectForKey:UIImagePickerControllerOriginalImage]);
    

    if (self.photoIndex == 0) {
        [imageView setImage:image];
    }
    else {
        [imageView2 setImage:image2];
     }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)twitterShare:(id)sender {
    if (self.shareEnabled == YES) {
        CGRect screenBound = [[UIScreen mainScreen] bounds];
        CGSize screenSize = screenBound.size;
        CGFloat screenWidth = screenSize.width;
        CGFloat screenHeight = screenSize.height;
        UIGraphicsBeginImageContext(CGSizeMake(screenHeight * 4, screenWidth * 4));
        
        CGContextRef            context = UIGraphicsGetCurrentContext();
        [image drawInRect:CGRectMake(0, 0, screenHeight * 4 /3, screenWidth * 4)];
        [image2 drawInRect: CGRectMake(screenHeight * 4 / 3, 0, screenHeight * 4 / 3, screenWidth * 4)];
        NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/combinedImg.jpg"];
        UIImage        *smallImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [UIImageJPEGRepresentation(smallImage, 0) writeToFile:jpgPath atomically:YES];
        NSLog(@"%@", jpgPath);
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:@"@waywayapp Check out this app!"];
            
            NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
            NSString *docDirectory = [sysPaths objectAtIndex:0];
            NSString *filePath = [NSString stringWithFormat:@"%@/combinedImg.jpg", docDirectory];
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
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"You have to take two photos." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (IBAction)facebookShare:(id)sender {
    if (self.shareEnabled == YES) {
        NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
        NSString *docDirectory = [sysPaths objectAtIndex:0];
        NSString *filePath = [NSString stringWithFormat:@"%@/combinedImg.jpg", docDirectory];
        UIImage * savedImg = [[UIImage alloc] initWithContentsOfFile:filePath];
        
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
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"You have to take two photos." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];

    }
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.photoIndex = 0;
    self.shareEnabled = NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
