//
//  WWServer.h
//  WayWay
//
//  Created by Ryan DeVore on 5/17/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@class WWSearchArgs;
@class WWCategory;
@class WWPlace;
@class WWPagedSearchResults;
@class WWUser;
@class WWPhoto;

extern NSString * const WWServerErrorDomain;

@interface WWServer : NSObject
{
    
}

// Properties
@property (nonatomic, copy) NSString* rootServerUrl;

// Initialization
- (id) initWithRoolUrl:(NSString*)rootUrl;

// Static Interface
+ (WWServer*) sharedInstance;

// User Account Management
- (UUHttpClient*) facebookLogin:(NSString*)accessToken
          accessTokenExpiration:(NSDate*)accessTokenExpiration
              completionHandler:(void (^)(NSError* error, WWUser* updatedUser))completionHandler;

- (UUHttpClient*) emailLogin:(NSString*)email
                    password:(NSString*)password
           completionHandler:(void (^)(NSError* error, WWUser* updatedUser))completionHandler;

- (UUHttpClient*) registerUser:(NSString*)email
                      password:(NSString*)password
                      fullName:(NSString*)fullName
             completionHandler:(void (^)(NSError* error, WWUser* updatedUser))completionHandler;

- (UUHttpClient*) uploadPushToken:(WWUser*)user token:(NSString*)token completion:(void (^)(NSError* error))completion;

// Account Linking
- (UUHttpClient*) user:(WWUser*)user
   linkFacebookAccount:(NSString*)accessToken
 accessTokenExpiration:(NSDate*)accessTokenExpiration
     completionHandler:(void (^)(NSError* error, WWUser* updatedUser))completionHandler;

- (UUHttpClient*) clearFacebookAuthForUser:(WWUser*)user completionHandler:(void (^)(NSError* error, WWUser* updatedUser))completionHandler;
- (UUHttpClient*) clearTwitterAuthForUser:(WWUser*)user completionHandler:(void (^)(NSError* error, WWUser* updatedUser))completionHandler;


// Search
- (UUHttpClient*) beginSearchPlaces:(WWSearchArgs*)searchArgs completionHandler:(void (^)(NSError* error, WWPagedSearchResults* results))completionHandler;
- (UUHttpClient*) fetchNextPlacesPage:(NSString*)fullUrl completionHandler:(void (^)(NSError* error, WWPagedSearchResults* results))completionHandler;

// Place Specific API
- (UUHttpClient*) beginFetchPlacePictures:(WWPlace*)place filter:(WWPhotoFilter)filter completionHandler:(void (^)(NSError* error, WWPagedSearchResults* results))completionHandler;
- (UUHttpClient*) fetchNextPicturesPage:(NSString*)fullUrl filter:(WWPhotoFilter)filter completionHandler:(void (^)(NSError* error, WWPagedSearchResults* results))completionHandler;
- (UUHttpClient*) beginFetchPlacePictures:(WWPlace*)place hashTag:(NSString*)hashTag completionHandler:(void (^)(NSError* error, WWPagedSearchResults* results))completionHandler;
- (UUHttpClient*) fetchNextPicturesHashTagPage:(NSString*)fullUrl completionHandler:(void (^)(NSError* error, WWPagedSearchResults* results))completionHandler;

- (UUHttpClient*) beginFetchPlaceHashtags:(WWPlace*)place
                                  hashtag:(NSString*)hashtag
                        completionHandler:(void (^)(NSError* error, WWPagedSearchResults* results))completionHandler;
- (UUHttpClient*) fetchNextHashtagPage:(NSString*)fullUrl completionHandler:(void (^)(NSError* error, WWPagedSearchResults* results))completionHandler;

// Favorites
- (UUHttpClient*) user:(WWUser*)user
        updateFavorite:(WWPlace*)place
            completion:(void (^)(NSError* error))completion;

- (UUHttpClient*) listUserFavorites:(WWUser*)user
                  completionHandler:(void (^)(NSError* error, WWPagedSearchResults* results))completionHandler;

// Text Search
- (UUHttpClient*) queryTextSearch:(NSString*)query
                         hashTags:(BOOL)searchHashTags
                   withSearchArgs:(WWSearchArgs*)searchArgs
                       completion:(void (^)(NSError* error, NSArray* results))completion;

- (UUHttpClient*) queryLocationSearch:(NSString*)query
                            mapRegion:(MKCoordinateRegion)mapRegion
                           completion:(void (^)(NSError* error, NSArray* results))completion;

// Menu
- (UUHttpClient*) listMenus:(WWPlace*)place
                 completion:(void (^)(NSError* error, NSArray* results))completion;

//Categories
- (UUHttpClient*) getStaticCategories:(void(^)(NSError* error, NSArray* results))completion;

//Featured hashtags
- (UUHttpClient*) featuredHashtagsWithLocation:(CLLocation*)location completion:(void(^)(NSError* error, NSArray* results))completion;

// Bad Photos
- (UUHttpClient*) reportBadPhoto:(NSNumber*)photoId completion:(void (^)(NSError* error))completion;

// Forgot Password
- (UUHttpClient*) forgotPassword:(NSString*)email completion:(void (^)(NSError* error))completion;

@end