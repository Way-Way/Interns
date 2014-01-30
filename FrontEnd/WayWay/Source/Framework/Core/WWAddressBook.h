//
//  WWAddressBook.h
//  WayWay
//
//  Created by Ryan DeVore on 8/2/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWAddressBook : NSObject

// One record per email
+ (NSArray*) listAllEmailAddresses;

// One record per phone number
+ (NSArray*) listAllPhoneNumbers;

@end