// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Ofer Mano.

#import <UIKit/UIKit.h>

#import "LTPhotoDescription.h"
#import "LTBackgroundLoaderProtocol.h"
#import "LTRecentPhotos.h"

NS_ASSUME_NONNULL_BEGIN

/// A class that manages a description table view (city's photos and recent photos).
@interface LTDescriptionsTable : UITableViewController

/// The description loader.
@property (strong, nonatomic) id<LTBackgroundLoaderProtocol> desscriptionLoader;

/// The descriptions to manage.
@property (strong,nonatomic) NSArray<LTPhotoDescription *> *descriptions;

/// The recent photos (need to push upon selection).
@property (strong,nonatomic) LTRecentPhotos *recentPhotos;

@end

NS_ASSUME_NONNULL_END
