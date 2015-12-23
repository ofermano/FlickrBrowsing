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

/// This class manages the recent photos chosen by the user.
/// it should be the model point of contact to controllers who should view the recent seen photos.
@interface LTRecentPhotos : NSObject

#pragma mark -
#pragma mark Initializer
#pragma mark -
/// Loads the recent photos from the persistent memory.
- (instancetype)init;

#pragma mark -
#pragma mark Object interface
#pragma mark -
/// Reloads the recent photos.
- (void)update;
/// Quesries to \c Photos
- (NSUInteger)getNumberOfPhotos;
/// Getting the title of the photo given its index.
- (NSString *)getTitleByIndex:(NSUInteger)index;
/// Getting the description of the photo given its index.
- (LTPhotoDescription *)getDescriptionByIndex:(NSUInteger)index;

#pragma mark -
#pragma mark Class interface
#pragma mark -
/// Adds a photo descrption as the most recent photo.
+ (void)pushPhotoDescription:(nullable LTPhotoDescription *)photoDescription;

@end

NS_ASSUME_NONNULL_END

