//
//  OverlayViewController.h
//  Camera App
//
//  Created by mo_r on 13/12/13.
//  Copyright (c) 2013 mo_r. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OverlayViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>{

    @public
    UIImagePickerController *pickerReference;
}

@end
