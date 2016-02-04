//
//  LTDescriptionsTableVC.h
//  Flickr Browsing
//
//  Created by Ofer Mano on 14/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "LTBackgroundLoaderProtocol.h"

@class LTPhotoDescription;
@class LTRecentPhotos;

NS_ASSUME_NONNULL_BEGIN

/// A class that manages a description table view (city's photos and recent photos).
@interface LTDescriptionsTableVC : UITableViewController

/// The description loader.
@property (strong, nonatomic, nullable) id<LTBackgroundLoaderProtocol> descriptionLoader;

@end

NS_ASSUME_NONNULL_END
