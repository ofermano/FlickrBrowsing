//
//  LTRecentPhotos.h
//  Flickr Browsing
//
//  Created by Ofer Mano on 16/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LTPhotoDescription.h"

/// This class manages the recent photos chosen by the user.
/// it should be the model point of contact to controllers who should view the recent seen photos.
@interface LTRecentPhotos : NSObject

/// Loads the recent photos from the persistent memory.
- (instancetype)init;


/// Reloads the recent photos.
- (void)update;

/// Quesries to \c Photos
- (NSUInteger)getNumberOfPhotos;
- (NSString *)getTitleByIndex:(NSUInteger)index;
- (LTPhotoDescription *)getDescriptionByIndex:(NSUInteger)index;


/// Adds a photo descrption as the most recent photo.
+ (void)pushPhotoDescription:(LTPhotoDescription *)photoDescription;

@end

