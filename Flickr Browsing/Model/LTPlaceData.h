//
//  LTPlaceData.h
//  Flickr Browsing
//
//  Created by Ofer Mano on 14/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// A simple struct that holds the data read from Flickr.
@interface LTPlaceData : NSObject

/// Initialises all parameters.
- (instancetype)initWithCountry:(NSString *)country
                       province:(NSString *)province
                           city:(NSString *)city
                     andPlaceID:(NSString *)placeID;

/// The country in which the photo was taken.
@property (readonly, nonatomic, nullable) NSString *country;

/// The province in which the photo was taken.
@property (readonly, nonatomic, nullable) NSString *province;

/// The city in which the photo was taken.
@property (readonly, nonatomic, nullable) NSString *city;

/// The place ID in which the photo was taken.
@property (readonly, nonatomic, nullable) NSString *place_id;

@end

NS_ASSUME_NONNULL_END
