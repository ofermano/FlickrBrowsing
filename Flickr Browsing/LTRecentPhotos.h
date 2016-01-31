//
//  LTRecentPhotos.h
//  Flickr Browsing
//
//  Created by Ofer Mano on 16/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LTPhotoDescription.h"
#import "LTBackgroundLoaderProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/// We store up to 20 recent photos.
static const int kHistoryLength = 20;

/// A class that load and set the recent photos
@interface LTRecentPhotos : NSObject <LTBackgroundLoaderProtocol>

/// Adds a photo descrption as the most recent photo.
- (void)push:(LTPhotoDescription *)photoDescription;

@end

NS_ASSUME_NONNULL_END
