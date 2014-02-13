//
//  WWSettings.m
//  WayWay
//
//  Created by Ryan DeVore on 5/17/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

#define WW_DEVICE_TOKEN @"WWDeviceToken"
#define WW_CURRENT_USER_KEY @"WWCurrentUserKey"
#define WW_CACHED_SEARCH_ARGS_KEY @"WWCachedSearchArgsKey"
#define WW_CURRENT_MAP_LOCATION_KEY @"WWCurrentMapLocationKey"
#define WW_GEOLOCALIZATION_KEY @"WWGeolocalizationKey"
#define WW_BAD_PHOTOS_KEY @"WWBadPhotosKey"
#define WW_RECENT_PLACE_SEARCHES @"WWRecentPlaceSearches"
#define WW_RECENT_HASH_TAG_SEARCHES @"WWRecentHashTagSearches"
#define WW_LAST_LAUNCH_TIME_KEY @"WWLastLaunchTimeKey"
#define WW_HAS_SEEN_INTRO_SLIDES_KEY @"WWHasSeenIntroSlidesKey"
#define WW_APP_LAUNCH_COUNT_KEY @"WWAppLaunchCountKey"
#define WW_RATE_IT_PREF_KEY @"WWRateItPrefKey"
#define WW_LAST_RATE_IT_POPUP_TIME @"WWLastRateItPopupTime"
#define WW_CATEGORY_DICTIONARY @"WWCategoryDictionary"

@implementation WWSettings

+ (WWUser*) currentUser
{
    NSDictionary* obj = [[NSUserDefaults standardUserDefaults] objectForKey:WW_CURRENT_USER_KEY];
    if (obj != nil)
    {
        WWUser* user = [WWUser userFromDictionary:obj];
        return user;
    }
    else
    {
        return nil;
    }
}

+ (void) setCurrentUser:(WWUser*)user
{
    [[NSUserDefaults standardUserDefaults] setObject:[user toDictionary] forKey:WW_CURRENT_USER_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString* userId = @"";
    if (user)
    {
        userId = [NSString stringWithFormat:@"%@", user.identifier];
    }
    
    [Flurry setUserID:userId];
}

+ (WWSearchArgs*) cachedSearchArgs
{
    NSDictionary* d = [[NSUserDefaults standardUserDefaults] objectForKey:WW_CACHED_SEARCH_ARGS_KEY];
    return [WWSearchArgs fromDictionary:d];
}

+ (void) saveCachedSearchArgs:(WWSearchArgs*)args
{
    NSDictionary* d = [args toDictionary];
    [[NSUserDefaults standardUserDefaults] setObject:d forKey:WW_CACHED_SEARCH_ARGS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (CLLocation*) currentMapLocation
{
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:WW_CURRENT_MAP_LOCATION_KEY];
    if (data)
    {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    else
    {
        return nil;
    }
}

+ (void) setCurrentMapLocation:(CLLocation*)location
{
    if (location)
    {
        NSData* data = [NSKeyedArchiver archivedDataWithRootObject:location];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:WW_CURRENT_MAP_LOCATION_KEY];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:WW_CURRENT_MAP_LOCATION_KEY];
        
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/*
+ (BOOL) isNotificationOn
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:WW_NOTIFICATIONS_KEY];
}

+ (void) toggleNotifications:(BOOL)enabled
{
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:WW_NOTIFICATIONS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}*/

/*
+ (BOOL) isFacebookSharingOn
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:WW_FACEBOOK_SHARING_KEY];
}

+ (void) toggleFacebookSharing:(BOOL)enabled
{
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:WW_FACEBOOK_SHARING_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL) isTwitterSharingOn
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:WW_TWITTER_SHARING_KEY];
}

+ (void) toggleTwitterSharing:(BOOL)enabled
{
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:WW_TWITTER_SHARING_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
*/
+ (BOOL) isGeolocalizationOn
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:WW_GEOLOCALIZATION_KEY];
}

+ (void) toggleGeolocalization:(BOOL)enabled
{
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:WW_GEOLOCALIZATION_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSMutableArray*) badPhotoList
{
    NSArray* existing = [[NSUserDefaults standardUserDefaults] objectForKey:WW_BAD_PHOTOS_KEY];
    if (!existing)
    {
        existing = @[];
    }
    
    return [NSMutableArray arrayWithArray:existing];
}

+ (void) addBadPhoto:(NSNumber*)photoId
{
    NSMutableArray* existing = [self badPhotoList];

    if (![existing containsObject:photoId])
    {
        [existing addObject:photoId];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:existing forKey:WW_BAD_PHOTOS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[WWServer sharedInstance] reportBadPhoto:photoId completion:nil];
}

+ (BOOL) isBadPhoto:(NSNumber*)photoId
{
    NSMutableArray* existing = [self badPhotoList];
    return [existing containsObject:photoId];
}

+ (NSArray*) recentPlaceSearchArgs
{
    return [WWAutoCompleteResult fromArray:[[NSUserDefaults standardUserDefaults] objectForKey:WW_RECENT_PLACE_SEARCHES]];
}

+ (void) addRecentPlaceSearch:(WWAutoCompleteResult*)obj
{
    [self addRecentSearch:obj key:WW_RECENT_PLACE_SEARCHES];
}

+ (void) clearRecentPlaceSearches
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:WW_RECENT_PLACE_SEARCHES];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray*) recentHashtagSearchArgs
{
    return [WWAutoCompleteResult fromArray:[[NSUserDefaults standardUserDefaults] objectForKey:WW_RECENT_HASH_TAG_SEARCHES]];
}

+ (void) addRecentHashtagSearch:(WWAutoCompleteResult*)obj
{
    [self addRecentSearch:obj key:WW_RECENT_HASH_TAG_SEARCHES];
}

+ (void) clearRecentHashtagSearches
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:WW_RECENT_HASH_TAG_SEARCHES];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (void) addRecentSearch:(WWAutoCompleteResult*)obj key:(NSString*)key
{
    NSMutableArray* updated = [NSMutableArray array];
    
    NSArray* existing = [WWAutoCompleteResult fromArray:[[NSUserDefaults standardUserDefaults] objectForKey:key]];
    if (existing)
    {
        [updated addObjectsFromArray:existing];
    }
    
    BOOL found = NO;
    
    for (WWAutoCompleteResult* o in existing)
    {
        if ([o.identifier isEqualToString:obj.identifier])
        {
            found = YES;
            break;
        }
    }
    
    if (!found)
    {
        obj.timestamp = [NSDate date];
        [updated addObject:obj];
    }
    
    NSMutableArray* md = [NSMutableArray array];
    
    for (WWAutoCompleteResult* r in updated)
    {
        [md addObject:[r toDictionary]];
    }
    
    [md sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO]]];
    
    while (md.count > 5)
    {
        [md removeLastObject];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:md forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDate*) lastLaunchTime
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:WW_LAST_LAUNCH_TIME_KEY];
}

+ (void) updateLastLaunchTime:(NSDate*)date
{
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:WW_LAST_LAUNCH_TIME_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL) hasSeenIntroSlides
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:WW_HAS_SEEN_INTRO_SLIDES_KEY];
}

+ (void) setHasSeenIntroSlides
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:WW_HAS_SEEN_INTRO_SLIDES_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (int) appLaunchCount
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:WW_APP_LAUNCH_COUNT_KEY];
}

+ (void) incrementAppLaunchCount
{
    int current = [self appLaunchCount];
    ++current;
    [[NSUserDefaults standardUserDefaults] setInteger:current forKey:WW_APP_LAUNCH_COUNT_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (WWRateItPref) rateItPref
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:WW_RATE_IT_PREF_KEY];
}

+ (void) updateRateItPref:(WWRateItPref)pref
{
    [[NSUserDefaults standardUserDefaults] setInteger:pref forKey:WW_RATE_IT_PREF_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (NSString*) getDeviceToken
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:WW_DEVICE_TOKEN];
}

+ (void) cacheDeviceToken:(NSString*)deviceToken
{
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:WW_DEVICE_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (NSDate*) lastRateItPopupTime
{
    id obj = [[NSUserDefaults standardUserDefaults] objectForKey:WW_LAST_RATE_IT_POPUP_TIME];
    if (!obj)
    {
        // A very old date that will trigger the rate it logic the first time.
        obj = [NSDate dateWithTimeIntervalSince1970:0];
    }
    
    return obj;
}

+ (void) setLastRateItPopupTime:(NSDate*)date
{
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:WW_LAST_RATE_IT_POPUP_TIME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(NSDictionary*)getCategoryDictionary
{
    NSDictionary* categoryDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:WW_CATEGORY_DICTIONARY];
    
    //Move this away from here WWStaticCategories ??
    if(!categoryDictionary || [categoryDictionary count] != 4)
    {
        [[WWServer sharedInstance] getStaticCategories:^(NSError* error, NSArray* response)
        {
            NSMutableDictionary* categoryDic = [NSMutableDictionary new];
            for (NSDictionary* d in response)
            {
                NSString* categroyName = [[d wwNonNullValueForKey:@"name"] lowercaseString];
                NSString* categroyId = [d wwNonNullValueForKey:@"id"];
                [categoryDic setObject:categroyId forKey:categroyName];
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:[categoryDic copy] forKey:WW_CATEGORY_DICTIONARY];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];

    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:WW_CATEGORY_DICTIONARY];
}

@end
