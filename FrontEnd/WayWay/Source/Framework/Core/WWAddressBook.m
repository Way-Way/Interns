//
//  WWAddressBook.m
//  WayWay
//
//  Created by Ryan DeVore on 8/2/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWAddressBook.h"
#import <AddressBook/AddressBook.h>

@implementation WWAddressBook

+ (NSString*) getString:(ABRecordRef)record field:(ABPropertyID)field
{
    NSString* result = nil;
    CFStringRef value = ABRecordCopyValue(record, field);
    if (value != nil)
    {
        result = [NSString stringWithFormat:@"%@", value];
        CFRelease(value);
    }
    
    return result;
}

+ (NSArray*) listMultiValue:(ABRecordRef)record field:(ABPropertyID)field 
{
    NSMutableArray* result = [NSMutableArray array];
    
    CFTypeRef list = ABRecordCopyValue(record, field);
    if (list)
    {
        int count = ABMultiValueGetCount(list);
        if (count > 0)
        {
            for (int j = 0; j < count; j++)
            {
                CFStringRef val = ABMultiValueCopyValueAtIndex(list, j);
                
                if (val != nil)
                {
                    [result addObject:[NSString stringWithFormat:@"%@", val]];
                    CFRelease(val);
                }
            }
        }
        
        CFRelease(list);
    }

    return [result copy];
}

+ (NSString*) getFullName:(ABRecordRef)record
{
    NSString* firstName = [self getString:record field:kABPersonFirstNameProperty];
    NSString* lastName = [self getString:record field:kABPersonLastNameProperty];
    
    NSMutableString* sb = [NSMutableString string];
    if (firstName)
    {
        [sb appendString:firstName];
    }
    
    if (lastName)
    {
        if (sb.length > 0)
        {
            [sb appendString:@" "];
        }
        
        [sb appendString:lastName];
    }
    
    return sb;
}

+ (UIImage*) getImage:(ABRecordRef)record
{
    UIImage* img = nil;
    
    if (ABPersonHasImageData(record))
    {
        CFDataRef data = ABPersonCopyImageDataWithFormat(record, kABPersonImageFormatThumbnail);
        img = [UIImage imageWithData:(__bridge NSData*)data];
    }
    
    return img;
    
    AB_EXTERN CFDataRef ABPersonCopyImageDataWithFormat(ABRecordRef person, ABPersonImageFormat format) __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_1);
    
    AB_EXTERN bool ABPersonHasImageData(ABRecordRef person);
}

+ (NSArray*) listEmails:(ABRecordRef)record
{
    return [self listMultiValue:record field:kABPersonEmailProperty];
}

+ (NSArray*) listPhoneNumbers:(ABRecordRef)record
{
    return [self listMultiValue:record field:kABPersonPhoneProperty];
}

+ (ABAddressBookRef) addressBook
{
    ABAddressBookRequestAccessWithCompletion(NULL, ^(bool granted, CFErrorRef error)
    {
        NSLog(@"granted: %d, error: %@", granted, (__bridge NSError*)error);
    });
    
    CFErrorRef err;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &err);
    return addressBook;
}

+ (NSArray*) listAllEmailAddresses
{
    NSMutableArray* results = [NSMutableArray array];
    
    ABAddressBookRef addressBook = [self addressBook];
    if (addressBook)
    {
        CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
        if (people != nil)
        {
            int count = CFArrayGetCount(people);
            for (int i = 0; i < count; i++)
            {
                ABRecordRef record = (ABRecordRef)CFArrayGetValueAtIndex(people, i);
                
                NSString* name = [self getFullName:record];
                if (name.length <= 0)
                    continue;
                
                UIImage* img = [self getImage:record];
                
                NSArray* emails = [self listEmails:record];
                for (NSString* email in emails)
                {
                    NSMutableDictionary* d = [NSMutableDictionary dictionary];
                    [d setValue:name forKey:@"name"];
                    [d setValue:email forKey:@"email"];
                    [d setValue:img forKey:@"photo"];
                    [results addObject:d];
                }
            }
            
            CFRelease(people);
        }
        
        CFRelease(addressBook);
    }

    NSArray* sda = @[ [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES] ];
    return [results sortedArrayUsingDescriptors:sda];
}

+ (NSArray*) listAllPhoneNumbers
{
    NSMutableArray* results = [NSMutableArray array];
    
    ABAddressBookRef addressBook = [self addressBook];
    if (addressBook)
    {
        CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
        if (people != nil)
        {
            int count = CFArrayGetCount(people);
            for (int i = 0; i < count; i++)
            {
                ABRecordRef record = (ABRecordRef)CFArrayGetValueAtIndex(people, i);
                
                NSString* name = [self getFullName:record];
                if (name.length <= 0)
                    continue;
                
                UIImage* img = [self getImage:record];
                
                NSArray* phones = [self listPhoneNumbers:record];
                for (NSString* phone in phones)
                {
                    NSMutableDictionary* d = [NSMutableDictionary dictionary];
                    [d setValue:name forKey:@"name"];
                    [d setValue:phone forKey:@"phone"];
                    [d setValue:img forKey:@"photo"];
                    [results addObject:d];
                }
            }
            
            CFRelease(people);
        }
        
        CFRelease(addressBook);
    }
    
    NSArray* sda = @[ [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES] ];
    return [results sortedArrayUsingDescriptors:sda];
}

@end
