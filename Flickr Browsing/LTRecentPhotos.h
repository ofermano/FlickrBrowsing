//
//  LTRecentPhotos.h
//  Flickr Browsing
//
//  Created by Ofer Mano on 16/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LTBackgroundLoaderProtocol.h"

@class LTPhotoDescription;

NS_ASSUME_NONNULL_BEGIN

/// The number of recent photos we store.
static const int kHistoryLength = 20;

/// A class that loads and sets the recent photos.
@interface LTRecentPhotos : NSObject <LTBackgroundLoaderProtocol>

/// Adds a photo descrption as the most recent photo.
- (void)push:(LTPhotoDescription *)photoDescription;

@end

NS_ASSUME_NONNULL_END
