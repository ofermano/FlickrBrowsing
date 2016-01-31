// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Ofer Mano.

#import "LTPlacesCollection.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTPlacesCollection()
@property (strong,nonatomic,readonly) NSArray *countries;
@property (strong,nonatomic,readonly) NSDictionary *placesByCountry;
@end

@implementation LTPlacesCollection

- (instancetype)initWithCountries:(NSArray *)countries andPlaces:(NSDictionary *)placesByCountry {
  if (self = [super init]) {
    _countries = countries;
    _placesByCountry = placesByCountry;
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
