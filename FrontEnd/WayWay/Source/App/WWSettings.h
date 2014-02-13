//
//  WWSettings.h
//  WayWay
//
//  Created by Ryan DeVore on 5/17/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@class WWUser;
@class WWSearchArgs;
@class WWAutoCompleteResult;

@interface WWSettings : NSObject

+ (WWUser*) currentUser;
+ (void) setCurrentUser:(WWUser*)user;

+ (WWSearchArgs*) cachedSearchArgs;
+ (void) saveCachedSearchArgs:(WWSearchArgs*)args;

+ (CLLocation*) currentMapLocation;
+ (void) setCurrentMapLocation:(CLLocation*)location;

+ (BOOL) isGeolocalizationOn;
+ (void) toggleGeolocalization:(BOOL)enabled;

+ (void) addBadPhoto:(NSNumber*)photoId;
+ (BOOL) isBadPhoto:(NSNumber*)photoId;
+ (NSMutableArray*) badPhotoList;

+ (NSArray*) recentPlaceSearchArgs;
+ (void) addRecentPlaceSearch:(WWAutoCompleteResult*)obj;
+ (void) clearRecentPlaceSearches;

+ (NSArray*) recentHashtagSearchArgs;
+ (void) addRecentHashtagSearch:(WWAutoCompleteResult*)obj;
+ (void) clearRecentHashtagSearches;

+ (NSDate*) lastLaunchTime;
+ (void) updateLastLaunchTime:(NSDate*)date;

+ (BOOL) hasSeenIntroSlides;
+ (void) setHasSeenIntroSlides;

+ (int) appLaunchCount;
+ (void) incrementAppLaunchCount;

+ (WWRateItPref) rateItPref; // 1=ignore this time, 2=ignore forever
+ (void) updateRateItPref:(WWRateItPref)pref;

+ (NSString*) getDeviceToken;
+ (void) cacheDeviceToken:(NSString*)deviceToken;

+ (NSDate*) lastRateItPopupTime;
+ (void) setLastRateItPopupTime:(NSDate*)date;

+(NSDictionary*)getCategoryDictionary;

@end
