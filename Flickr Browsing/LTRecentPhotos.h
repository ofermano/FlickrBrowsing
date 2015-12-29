//
//  LTRecentPhotos.h
//  Flickr Browsing
//
//  Created by Ofer Mano on 16/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LTPhotoDescription.h"

NS_ASSUME_NONNULL_BEGIN

/// A model class that holds the recent photos selected by the user.
/// Since there should be only single list in the application (regardless where the user chose the
/// photo) we should have a Singletone object.
@interface LTRecentPhotos : NSObject

/// A factory to create only single list of recent photos.
+ (LTRecentPhotos *)list;

/// Adds a photo descrption as the most recent photo.
- (void)push:(LTPhotoDescription *)photoDescription;
/// Reloads the recent photos.
- (void)update;
/// Quesries to \c Photos
- (NSUInteger)getNumberOfPhotos;
/// Getting the title of the photo given its index.
- (NSString *)getTitleByIndex:(NSUInteger)index;
/// Getting the description of the photo given its index.
- (LTPhotoDescription *)getDescriptionByIndex:(NSUInteger)index;


@end

NS_ASSUME_NONNULL_END

