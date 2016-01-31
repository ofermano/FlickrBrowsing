//
//  LTFlickrPlaces.m
//  Flickr Browsing
//
//  Created by Ofer Mano on 15/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import "LTFlickrPlacesLoader.h"

#import "FlickrFetcher.h"
#import "LTPlaceData.h"
#import "LTPlacesCollection.h"

NS_ASSUME_NONNULL_BEGIN


@implementation LTFlickrPlacesLoader

#pragma mark -
#pragma mark Implementing background loading protocol
#pragma mark -

- (void)load {
  dispatch_queue_t queue = dispatch_queue_create("LoadQueue", NULL);
  dispatch_async(queue, ^{
    LTPlacesCollection *places = [self backgroundLoad];
    [self notify:places];
  });
}

- (NSString *)observingKey {
  return @"PlacesLoaded";
}

- (NSString *)dataKey {
  return @"places";}

- (void)notify:(LTPlacesCollection *)places {
  [[NSNotificationCenter defaultCenter] postNotificationName:[self observingKey]
                                                      object:self
                                                    userInfo:@{[self dataKey]:places}];
}

#pragma mark -
#pragma mark Loading the data
#pragma mark -

- (LTPlacesCollection *)backgroundLoad {
  NSDictionary *placesByCountry = [self getFlickerData];
  NSArray *countries = [self sortPlaces:placesByCountry];
  return [[LTPlacesCollection alloc] initWithCountries:countries andPlaces:placesByCountry];
}

- (NSDictionary *)getFlickerData {
  NSMutableDictionary *placesByCountry = [[NSMutableDictionary alloc] init];
  NSArray *flickrPlaces = [self getFlickrPlaces];
  for (NSDictionary *flickrPlace in flickrPlaces) {
    LTPlaceData *place = [self convertToSystemPlace:flickrPlace];
    [self addPlace:place to:placesByCountry];
  }
  return placesByCountry;
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
  NSString *placeID = [flickrPlace valueForKey:FLICKR_PLACE_ID];
  LTPlaceData *data = [[LTPlaceData alloc] initWithCountry:[record lastObject]
                                                  province:([record count] ==3 ? record[1]:nil)
                                                      city:record[0]
                                                andPlaceID:placeID];
  return data;
}

- (void)addPlace:(LTPlaceData *)place to:(NSMutableDictionary *)placesByCountry {
  NSMutableArray *countryPlaces = [self getCountryPlaces:place.country from:placesByCountry];
  [countryPlaces addObject:place];
}

- (NSMutableArray *)getCountryPlaces:(NSString *)country
                                from:(NSMutableDictionary *)placesByCountry {
  NSMutableArray *countryPlaces = [placesByCountry objectForKey:country];
  if (!countryPlaces) {
    countryPlaces = [[NSMutableArray alloc] init];
    [placesByCountry setObject:countryPlaces forKey:country];
  }
  return countryPlaces;
}

- (NSArray *)sortPlaces:(NSDictionary *)placesByCountry {
  NSArray *countries = [[NSMutableArray alloc] init];
  countries = [[placesByCountry allKeys] sortedArrayUsingSelector:@selector(compare:)];
  for (NSMutableArray *placesInCountry in placesByCountry.allValues) {
    [placesInCountry sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"city"
                                                                          ascending:YES]]];
  }
  return countries;
}

@end

NS_ASSUME_NONNULL_END
