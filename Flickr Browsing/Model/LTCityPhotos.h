//
//  LTCityPhotos.h
//  Flickr Browsing
//
//  Created by Ofer Mano on 14/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// \c PlacePhotos is the class managing the photos in FLickr from a single city.
/// The class should be used as the model point-of-contact for MVCs that needs to
/// work with photos from a single city.
@interface LTCityPhotos : NSObject

/// The designated \c init function requires the Flicker place ID.
- (instancetype)initWithPlaceID:(NSString *)placeID NS_DESIGNATED_INITIALIZER;


- (void)loadPhotos;

- (NSUInteger)getNumberOfPhotos;
- (NSString *)getTitleByIndex:(NSUInteger)index;
- (NSString *)getDescriptionByIndex:(NSUInteger)index;
- (NSURL *)getImageURLByIndex:(NSUInteger)index;


@end

