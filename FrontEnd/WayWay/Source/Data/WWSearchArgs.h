//
//  WWSearchArgs.h
//  WayWay
//
//  Created by Ryan DeVore on 5/31/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"


@interface WWSearchArgs : NSObject

//Autocomplete place search
#warning - RB : Put an enum here !!!
@property (nonatomic, copy) NSString* autoCompleteType;

@property (nonatomic, copy) NSString* autoCompleteArg;
@property (nonatomic, copy) NSString* lastAutoCompleteInput;

//Location
@property (nonatomic, copy) NSString* locationName;

@property (nonatomic, strong) NSNumber* minlatitude;
@property (nonatomic, strong) NSNumber* maxlatitude;
@property (nonatomic, strong) NSNumber* minlongitude;
@property (nonatomic, strong) NSNumber* maxlongitude;

//Price
@property (nonatomic, strong) NSNumber* priceOne;
@property (nonatomic, strong) NSNumber* priceTwo;
@property (nonatomic, strong) NSNumber* priceThree;
@property (nonatomic, strong) NSNumber* priceFour;

//Category
@property (nonatomic, strong) NSNumber* categoryCoffee;
@property (nonatomic, strong) NSNumber* categoryBar;
@property (nonatomic, strong) NSNumber* categoryRestaurant;
@property (nonatomic, strong) NSNumber* categorySnack;

//Hour
@property (nonatomic, strong) NSNumber* openRightNow;

//Is trending
@property (nonatomic, strong) NSNumber* trendingOnly;

- (NSString*) selectedPrices;
- (NSString*) selectedCategories;

- (NSDictionary*) toDictionary;
+ (instancetype) fromDictionary:(NSDictionary*)dictionary;

- (MKCoordinateRegion) coordinateRegion;
- (void) setGeoboxFromMapRegion:(MKCoordinateRegion)region;
- (void) setGeoboxToCurrentLocation;
- (void) setGeoboxFromLocation:(CLLocation*)location;
- (BOOL) hasGeoBox;

@end