//
//  LTFlickrPlaces.h
//  Flickr Browsing
//
//  Created by Ofer Mano on 15/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LTBackgroundLoaderProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/// A class that loads the places available in Flickr.
@interface LTFlickrPlacesLoader : NSObject <LTBackgroundLoaderProtocol>

@end

NS_ASSUME_NONNULL_END
