//
//  LTCityPhotos.h
//  Flickr Browsing
//
//  Created by Ofer Mano on 14/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "LTPhotoDescription.h"
#import "LTBackgroundLoaderProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/// A class that loads the descriptions of the photos for a given city.
@interface LTCityPhotosLoader : NSObject <LTBackgroundLoaderProtocol>

/// A property to set the place id.
@property (strong,nonatomic) NSString *placeID;

@end

NS_ASSUME_NONNULL_END
