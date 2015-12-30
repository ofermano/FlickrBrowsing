//
//  LTFlickrPlaces.m
//  Flickr Browsing
//
//  Created by Ofer Mano on 15/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import "LTFlickrPlaces.h"

#import "FlickrFetcher.h"
#import "LTPlaceData.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTFlickrPlaces()
@property (strong, nonatomic, nullable) NSMutableDictionary *placesByCountry;
@property (strong, nonatomic, nullable) NSArray *sortedCountries;
@end

@implementation LTFlickrPlaces

#pragma mark -
#pragma mark Initializers
#pragma mark -
- (instancetype)init {
  if (self = [super init]) {
    [self getFlickerData];
    [self sortPlaces];
  }
  return self;
}

- (void)getFlickerData {
  NSArray *flickrPlaces = [self getFlickrPlaces];
  for (NSDictionary *flickrPlace in flickrPlaces) {
    LTPlaceData *place = [self convertToSystemPlace:flickrPlace];
    [self addPlace:place];
  }
}

- (NSArray *)getFlickrPlaces {
  NSURL *topPlacesURL = [FlickrFetcher URLforTopPlaces];
  NSData *topPlacesData = [NSData dataWithContentsOfURL:topPlacesURL];
  NSDictionary *topPlacesContainer = [NSJSONSerialization JSONObjectWithData:topPlacesData
                                                                     options:0
                                                                       error:nil];
  return [topPlacesContainer valueForKeyPath:FLICKR_RESULTS_PLACES];
}

// The Flickr data structure is a sting in the following format:
// "<city>, <province/state>, <country>" or "<city>, <country>"
- (LTPlaceData *)convertToSystemPlace:(NSDictionary *)flickrPlace {
  NSArray *record = [[flickrPlace valueForKey:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "];
  LTPlaceData *data = [LTPlaceData alloc];
  data.city = record[0];
  data.country = [record lastObject];
  data.province = [record count] == 3 ? record[1] : nil;
  data.place_id = [flickrPlace valueForKey:FLICKR_PLACE_ID];
  return data;
}

- (void)addPlace:(LTPlaceData *)place {
  NSMutableArray *countryPlaces = [self getCountryPlaces:place.country];
  [countryPlaces addObject:place];
}

- (NSMutableArray *)getCountryPlaces:(NSString *)country {
  NSMutableArray *countryPlaces = [self.placesByCountry objectForKey:country];
  if (!countryPlaces) {
    countryPlaces = [[NSMutableArray alloc] init];
    [self.placesByCountry setObject:countryPlaces forKey:country];
  }
  return countryPlaces;
}

- (void)sortPlaces {
  self.sortedCountries = [[self.placesByCountry allKeys]
                          sortedArrayUsingSelector:@selector(compare:)];
  for (NSMutableArray *placesInCountry in self.placesByCountry.allValues) {
    [placesInCountry sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"city"
                                                                          ascending:YES]]];
  }
}

#pragma mark -
#pragma mark Queries
#pragma mark -
- (nullable NSMutableDictionary *)placesByCountry {
  if (!_placesByCountry) {
    _placesByCountry = [[NSMutableDictionary alloc] init];
  }
  return _placesByCountry;
}

- (NSInteger)getNumberOfCountries {
  return [self.sortedCountries count];
}

- (NSInteger)getNumberOfCitiesInCountry:(NSInteger)countryIndex {
  NSString *country = self.sortedCountries[countryIndex];
  return [[self.placesByCountry objectForKey:country] count];
}

- (nullable NSString *)getCountryByIndex:(NSInteger)countryIndex {
  return self.sortedCountries[countryIndex];
}

- (nullable NSString *)getCityInCountry:(NSString *)country withIndex:(NSInteger)cityIndex {
  LTPlaceData *place = [self.placesByCountry objectForKey:country][cityIndex];
  return place.city;
}

- (nullable NSString *)getProvinceInCountry:(NSString *)country withIndex:(NSInteger)cityIndex {
  LTPlaceData *place = [self.placesByCountry objectForKey:country][cityIndex];
  return place.province;
}

- (nullable LTCityPhotos *)getImagesInCountry:(NSString *)country withIndex:(NSInteger)cityIndex {
  LTPlaceData *place = [self.placesByCountry objectForKey:country][cityIndex];
  return [[LTCityPhotos alloc] initWithPlaceID:place.place_id];
}



@end


NS_ASSUME_NONNULL_END
