// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Ofer Mano.

#import <Foundation/Foundation.h>

@class LTPlaceData;

NS_ASSUME_NONNULL_BEGIN

/// A collection of cities per country. Cities are sorted inside the countries and countries are
/// also sorted.
@interface LTPlacesCollection : NSObject

/// A init function with the countries and dictionary of cities
- (instancetype)initWithCountries:(NSArray<NSString *> *)countries
                        andPlaces:(NSDictionary<NSString *, NSArray *> *)placesByCountry;

/// Returns the number of countries.
- (NSInteger)getNumberOfCountries;

/// Returns the number of cities given a country index.
- (NSInteger)getNumberOfCitiesInCountry:(NSInteger)countryIndex;

/// Returns the country given its index.
- (nullable NSString *)getCountryByIndex:(NSInteger)countryIndex;

/// Returns a city given a country and city index.
- (nullable NSString *)getCityInCountry:(NSString *)country withIndex:(NSInteger)cityIndex;

/// Returns a province given a country and city index.
- (nullable NSString *)getProvinceInCountry:(NSString *)country
                                  withIndex:(NSInteger)cityIndex;

/// Returns the city ID given country and city index.
- (nullable NSString *)getPlaceIDInCountry:(NSString *)country withIndex:(NSInteger)cityIndex;

@end

NS_ASSUME_NONNULL_END
