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

@interface LTFlickrPlacesLoader()

/// The observing key.
@property (strong, nonatomic) NSString *notificationName;

/// The key to send the loaded data.
@property (strong, nonatomic) NSString *dataKey;

@end

@implementation LTFlickrPlacesLoader

- (instancetype)initWithNotificationName:(nullable NSString *)notificationName
                              andDataKey:(nullable NSString *)dataKey {
  if (self = [super init]) {
    _notificationName = notificationName;
    _dataKey = dataKey;
  }
  return self;
}

#pragma mark -
#pragma mark LTBackgroundLoaderProtocol
#pragma mark -

- (void)load {
  if (!self.notificationName || !self.dataKey) {
    return;
  }
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
  dispatch_async(queue, ^{
    LTPlacesCollection *places = [self backgroundLoad];
    [self notify:places];
  });
}

- (void)notify:(LTPlacesCollection *)places {
  [[NSNotificationCenter defaultCenter] postNotificationName:self.notificationName
                                                      object:self
                                                    userInfo:@{self.dataKey:places}];
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
                                                  province:([record count] == 3 ? record[1] : nil)
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
    countryPlaces = [NSMutableArray array];
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
