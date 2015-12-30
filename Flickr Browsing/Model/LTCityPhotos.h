//
//  LTCityPhotos.h
//  Flickr Browsing
//
//  Created by Ofer Mano on 14/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// \c PlacePhotos is the class managing the photos in FLickr from a single city.
/// The class should be used as the model point-of-contact for MVCs that needs to
/// work with photos from a single city.
@interface LTCityPhotos : NSObject

/// The designated \c init function requires the Flicker place ID.
- (instancetype)initWithPlaceID:(NSString *)placeID NS_DESIGNATED_INITIALIZER;

/// Loading all the photos from this city from the Flickr site.
- (void)loadPhotos;

/// Getting the number of photos
- (NSUInteger)getNumberOfPhotos;

/// Get the photo title given the index.
- (nullable NSString *)getTitleByIndex:(NSUInteger)index;

/// Get the photo description given the index.
- (nullable NSString *)getDescriptionByIndex:(NSUInteger)index;

/// Get the photo URL given the index.
- (nullable NSURL *)getImageURLByIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END


