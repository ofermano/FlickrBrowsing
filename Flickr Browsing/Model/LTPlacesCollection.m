// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Ofer Mano.

#import "LTPlacesCollection.h"

#import "LTPlaceData.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTPlacesCollection()

/// A sorted array of the countries.
@property (readonly, nonatomic) NSArray *countries;

// A dictionary that holds for each country its array of cities.
@property (readonly, nonatomic) NSDictionary *placesByCountry;

@end

@implementation LTPlacesCollection

- (instancetype)initWithCountries:(NSArray *)countries andPlaces:(NSDictionary *)placesByCountry {
  if (self = [super init]) {
    _countries = [countries copy];
    _placesByCountry = [placesByCountry copy];
  }
  return self;
}

- (NSInteger)getNumberOfCountries {
  return [self.countries count];
}

- (NSInteger)getNumberOfCitiesInCountry:(NSInteger)countryIndex {
  NSString *country = self.countries[countryIndex];
  return [[self.placesByCountry objectForKey:country] count];
}

- (nullable NSString *)getCountryByIndex:(NSInteger)countryIndex {
  return self.countries[countryIndex];
}

- (nullable NSString *)getCityInCountry:(NSString *)country withIndex:(NSInteger)cityIndex {
  LTPlaceData *place = [self.placesByCountry objectForKey:country][cityIndex];
  return place.city;
}

- (nullable NSString *)getProvinceInCountry:(NSString *)country withIndex:(NSInteger)cityIndex {
  LTPlaceData *place = [self.placesByCountry objectForKey:country][cityIndex];
  return place.province;
}

- (nullable NSString *)getPlaceIDInCountry:(NSString *)country withIndex:(NSInteger)cityIndex {
  LTPlaceData *place = [self.placesByCountry objectForKey:country][cityIndex];
  return place.place_id;
}

@end

NS_ASSUME_NONNULL_END
