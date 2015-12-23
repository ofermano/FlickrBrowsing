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
/// This struct should be used in order to store the read data in data structure.
@interface LTPlaceData : NSObject

/// The country in width the photo was taken place.
@property (strong, nonatomic, nullable) NSString *country;

/// The province in width the photo was taken place.
@property (strong, nonatomic, nullable) NSString *province;

/// The city in width the photo was taken place.
@property (strong, nonatomic, nullable) NSString *city;

/// The place ID in width the photo was taken place.
@property (strong, nonatomic, nullable) NSString *place_id;

@end

NS_ASSUME_NONNULL_END

