//
//  CameraAppViewController.m
//  Camera App
//
//  Created by mo_r on 21/11/13.
//  Copyright (c) 2013 mo_r. All rights reserved.
//

#import "CameraAppViewController.h"
#import <Social/Social.h>

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
    if (self.photoIndex == 2)
        self.photoIndex = 0;
    self.photoIndex++;
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    NSLog(@"X: %f   Y: %f", screenWidth, screenHeight);
    NSLog(@"%lu", (unsigned long)self.photoIndex);
    
    self.photoIndex == 1 ?  (image = [info objectForKey:UIImagePickerControllerOriginalImage]) :
                            (image2 = [info objectForKey:UIImagePickerControllerOriginalImage]);
    
    UIGraphicsBeginImageContext(CGSizeMake(screenHeight * 4, screenWidth * 4));
    
    CGContextRef            context = UIGraphicsGetCurrentContext();
    [image drawInRect:CGRectMake(0, screenWidth, screenHeight * 2, screenWidth * 2)];
    [image2 drawInRect: CGRectMake(screenHeight * 2, screenWidth, screenHeight * 2, screenWidth * 2)];
    UIImage        *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/combinedImg.jpg"];
    if (self.photoIndex == 1)
        [imageView setImage:image];
    else {
        [imageView setImage:smallImage];
        [UIImageJPEGRepresentation(smallImage, 0) writeToFile:jpgPath atomically:YES];
        NSLog(@"%@", jpgPath);
     }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)tweet:(id)sender {
    if (self.photoIndex == 2) {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:@"@waywayapp This is a default tweet!"];
            
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

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.photoIndex = 0;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
