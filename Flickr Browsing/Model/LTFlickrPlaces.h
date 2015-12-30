//
//  LTFlickrPlaces.h
//  Flickr Browsing
//
//  Created by Ofer Mano on 15/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LTCityPhotos.h"

NS_ASSUME_NONNULL_BEGIN

/// This class manages the Flickr places.
/// It should be used as the model point of contact to an MVC that wants to work with Flickr places.
@interface LTFlickrPlaces : NSObject

#pragma mark -
#pragma mark Initializer
#pragma mark -

/// Initializing and getting all the places from the Flickr site.
- (instancetype)init;

#pragma mark -
#pragma mark Interface
#pragma mark -

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
/// Getting the \c LTCityPhotos given a country and city index.
- (nullable LTCityPhotos *)getImagesInCountry:(NSString *)country
                                    withIndex:(NSInteger)cityIndex;


@end

NS_ASSUME_NONNULL_END

