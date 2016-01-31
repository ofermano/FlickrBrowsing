// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Ofer Mano.

#import <Foundation/Foundation.h>

#import "LTPlaceData.h"

NS_ASSUME_NONNULL_BEGIN

/// A class of heirarchy of sorted country and cities.
@interface LTPlacesCollection : NSObject

/// A init function with the countries and dictionry pf cities
- (instancetype)initWithCountries:(NSArray *)countries andPlaces:(NSDictionary *)placesByCountry;

/// Getting the number of countries.
- (NSInteger)getNumberOfCountries;

/// Getting the number of cities given a country index.
- (NSInteger)getNumberOfCitiesInCountry:(NSInteger)countryIndex;

/// Getting the country given its index.
- (nullable NSString *)getCountryByIndex:(NSInteger)countryIndex;

/// Getting a city given a country and city index.
- (nullable NSString *)getCityInCountry:(NSString *)country withIndex:(NSInteger)cityIndex;

/// Getting a province given a country and city index.
- (nullable NSString *)getProvinceInCountry:(NSString *)country
                                  withIndex:(NSInteger)cityIndex;

/// Getting the city ID given country and city index.
- (nullable NSString *)getPlaceIDInCountry:(NSString *)country withIndex:(NSInteger)cityIndex;

@end

NS_ASSUME_NONNULL_END
