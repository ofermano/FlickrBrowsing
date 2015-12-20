//
//  LTFlickrPlaces.h
//  Flickr Browsing
//
//  Created by Ofer Mano on 15/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LTCityPhotos.h"

/// This class manages the Flickr places.
/// It should be used as the model point of contact to an MVC that wants to work with Flickr places.
@interface LTFlickrPlaces : NSObject

- (instancetype)init;


- (NSInteger)getNumberOfCountries;
- (NSInteger)getNumberOfCitiesInCountry:(NSInteger)countryIndex;
- (NSString *)getCountryByIndex:(NSInteger)countryIndex;
- (NSString *)getCityInCountry:(NSString *)country withIndex:(NSInteger)cityIndex;
- (NSString *)getProvinceInCountry:(NSString *)country withIndex:(NSInteger)cityIndex;
- (LTCityPhotos *)getImagesInCountry:(NSString *)country withIndex:(NSInteger)cityIndex;


@end

