//
//  WWSearchArgs.m
//  WayWay
//
//  Created by Ryan DeVore on 5/31/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@implementation WWSearchArgs

- (instancetype) initFromDictionary:(NSDictionary*)dictionary
{
    self = [self init];
    
    if (self != nil && [dictionary isKindOfClass:[NSDictionary class]])
    {
        
        //Location
        self.locationName = [dictionary wwNonNullValueForKey:@"locationName"];
        self.maxlatitude = [dictionary wwNonNullValueForKey:@"max_latitude"];
        self.minlatitude = [dictionary wwNonNullValueForKey:@"min_latitude"];
        self.maxlongitude = [dictionary wwNonNullValueForKey:@"max_longitude"];
        self.minlongitude = [dictionary wwNonNullValueForKey:@"min_longitude"];
        
        //Autocomplete search
        self.autoCompleteType = [dictionary wwNonNullValueForKey:@"autoCompleteType"];
        self.autoCompleteArg = [dictionary wwNonNullValueForKey:@"autoCompleteArg"];
        self.lastAutoCompleteInput = [dictionary wwNonNullValueForKey:@"lastAutoCompleteInput"];
        
        //Price
        self.priceOne = [dictionary wwNonNullValueForKey:@"priceOne"];
        self.priceTwo = [dictionary wwNonNullValueForKey:@"priceTwo"];
        self.priceThree = [dictionary wwNonNullValueForKey:@"priceThree"];
        self.priceFour = [dictionary wwNonNullValueForKey:@"priceFour"];
        
        //Category
        self.categoryCoffee = [dictionary wwNonNullValueForKey:@"categoryCoffee"];
        self.categoryBar = [dictionary wwNonNullValueForKey:@"categoryBar"];
        self.categoryRestaurant = [dictionary wwNonNullValueForKey:@"categoryRestaurant"];
        self.categorySnack = [dictionary wwNonNullValueForKey:@"categorySnack"];
        
        //Hours
        self.openRightNow = [dictionary wwNonNullValueForKey:@"openRightNow"];
        
        //isTrending
        self.trendingOnly = [dictionary wwNonNullValueForKey:@"trendingOnly"];
    }
    
    return self;
}

+ (instancetype) fromDictionary:(NSDictionary*)dictionary
{
    if (dictionary)
    {
        return [[[self class] alloc] initFromDictionary:dictionary];
    }
    else
    {
        return [[[self class] alloc] init];
    }
}

- (NSDictionary*) toDictionary
{
    NSMutableDictionary* d = [NSMutableDictionary dictionary];
    [d setValue:self.locationName forKey:@"locationName"];
    
    [d setValue:self.minlatitude forKey:@"min_latitude"];
    [d setValue:self.maxlatitude forKey:@"max_latitude"];
    [d setValue:self.minlongitude forKey:@"min_longitude"];
    [d setValue:self.maxlongitude forKey:@"max_longitude"];
    
    [d setValue:self.autoCompleteType forKey:@"autoCompleteType"];
    [d setValue:self.autoCompleteArg forKey:@"autoCompleteArg"];
    [d setValue:self.lastAutoCompleteInput forKey:@"lastAutoCompleteInput"];
    
    [d setValue:self.priceOne forKey:@"priceOne"];
    [d setValue:self.priceTwo forKey:@"priceTwo"];
    [d setValue:self.priceThree forKey:@"priceThree"];
    [d setValue:self.priceFour forKey:@"priceFour"];
    
    [d setValue:self.categoryCoffee forKey:@"categoryCoffee"];
    [d setValue:self.categoryBar forKey:@"categoryBar"];
    [d setValue:self.categoryRestaurant forKey:@"categoryRestaurant"];
    [d setValue:self.categorySnack forKey:@"categorySnack"];
    
    [d setValue:self.openRightNow forKey:@"openRightNow"];
    
    [d setValue:self.trendingOnly forKey:@"trendingOnly"];
    
    return [d copy];
}

- (MKCoordinateRegion) coordinateRegion
{
    CLLocationDegrees latCenter = (self.maxlatitude.doubleValue + self.minlatitude.doubleValue)/2.0;
    CLLocationDegrees lonCenter = (self.maxlongitude.doubleValue + self.minlongitude.doubleValue)/2.0;
    
    CLLocationDegrees latDelta = (self.maxlatitude.doubleValue - self.minlatitude.doubleValue);//2.0;
    CLLocationDegrees lonDelta = (self.maxlongitude.doubleValue - self.minlongitude.doubleValue);//2.0;
    
    MKCoordinateRegion region;
    region.center = CLLocationCoordinate2DMake(latCenter, lonCenter);
    region.span = MKCoordinateSpanMake(latDelta, lonDelta);
    return region;
}


- (void) setGeoboxFromMapRegion:(MKCoordinateRegion)region
{
    CLLocationCoordinate2D center = region.center;
    
    
    //Construct one that only has half the longitudinal size
    //Why this numbers 2 and 0.8???
    MKCoordinateSpan span = region.span;
    double latitudeDelta = span.latitudeDelta/2.0; // * 0.8;
    double longitudeDelta = span.longitudeDelta/2.0; // * 0.8;
    
    NSNumber* maxlatitude = [NSNumber numberWithDouble:(center.latitude + latitudeDelta)];
    NSNumber* minlatitude = [NSNumber numberWithDouble:(center.latitude - latitudeDelta)];
    NSNumber* maxlongitude = [NSNumber numberWithDouble:(center.longitude + longitudeDelta)];
    NSNumber* minlongitude = [NSNumber numberWithDouble:(center.longitude - longitudeDelta)];
    
    self.maxlatitude = maxlatitude;
    self.minlatitude = minlatitude;
    self.maxlongitude = maxlongitude;
    self.minlongitude = minlongitude;
    
    //nil shows Current location on filter
    self.locationName = nil;
}

- (void) setGeoboxToCurrentLocation
{
    CLLocation* loc = [[UULocationManager sharedInstance] currentLocation];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc.coordinate, WW_DEFAULT_SEARCH_RADIUS, WW_DEFAULT_SEARCH_RADIUS);
    
    [self setGeoboxFromMapRegion:region];
}

- (void) setGeoboxFromLocation:(CLLocation*)location
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, WW_DEFAULT_SEARCH_RADIUS, WW_DEFAULT_SEARCH_RADIUS);
    [self setGeoboxFromMapRegion:region];
}

- (BOOL) hasGeoBox
{
    if (!self.minlatitude || !self.minlongitude ||
        !self.maxlatitude || !self.maxlongitude)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (NSString*) selectedPrices
{
    NSMutableArray* a = [NSMutableArray array];
    
    if (self.priceOne && self.priceOne.boolValue)
    {
        [a addObject:@"$"];
    }
    
    if (self.priceTwo && self.priceTwo.boolValue)
    {
        [a addObject:@"$$"];
    }
    
    if (self.priceThree && self.priceThree.boolValue)
    {
        [a addObject:@"$$$"];
    }
    
    if (self.priceFour && self.priceFour.boolValue)
    {
        [a addObject:@"$$$$"];
    }
    
    if (a.count > 0)
    {
        return [a componentsJoinedByString:@","];
    }
    else
    {
        return nil;
    }
}

- (NSString*) selectedCategories
{
    NSMutableArray* a = [NSMutableArray array];
    NSDictionary* categoryDic = [WWSettings getCategoryDictionary];
    
    if(!categoryDic)
        return nil;
    
    id categoryBarId = [categoryDic objectForKey:WW_CATEGORY_BARS_NIGHTLIFE];
    id categoryCoffeeId = [categoryDic objectForKey:WW_CATEGORY_COFFEE_TEA];
    id categoryRestaurantId = [categoryDic objectForKey:WW_CATEGORY_RESTAURANTS];
    id categorySnackId = [categoryDic objectForKey:WW_CATEGORY_SNACKS];
    
    if (self.categoryBar && self.categoryBar.boolValue && categoryBarId)
    {
        [a addObject:categoryBarId];
    }
    
    if (self.categoryCoffee && self.categoryCoffee.boolValue && categoryCoffeeId)
    {
        [a addObject:categoryCoffeeId];
    }
    
    if (self.categoryRestaurant && self.categoryRestaurant.boolValue && categoryRestaurantId)
    {
        [a addObject:categoryRestaurantId];
    }
    
    if (self.categorySnack && self.categorySnack.boolValue && categorySnackId)
    {
        [a addObject:categorySnackId];
    }
    
    if (a.count > 0)
    {
        return [a componentsJoinedByString:@","];
    }
    else
    {
        return nil;
    }
}

@end
