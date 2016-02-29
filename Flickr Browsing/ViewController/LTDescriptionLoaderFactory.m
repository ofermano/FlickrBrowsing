// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Ofer Mano.

#import "LTDescriptionLoaderFactory.h"

#import "LTCityPhotosLoader.h"
#import "LTRecentPhotos.h"

NS_ASSUME_NONNULL_BEGIN

@implementation LTDescriptionLoaderFactory

/// The key for recent photos loading notification.
NSString *kRecentPhotosNotificationKey = @"RecentDescriptionsLoaded";

/// The key for recent photos loading notification.
NSString *kCityPhotosNotificationKey = @"CityDescriptionsLoaded";

/// The key for the loaded recent photos.
NSString *kDescriptionsKey = @"descriptions";

+ (nullable id<LTBackgroundLoaderProtocol>)allocateDescriptionLoaderForName:(NSString *)name {
  if ([name isEqual: @"City"]) {
    return [[LTCityPhotosLoader alloc] initWithNotificationName:kCityPhotosNotificationKey
                                                     andDataKey:kDescriptionsKey];
  }
  else if ([name isEqual: @"Recent"]) {
    return [[LTRecentPhotos alloc] initWithNotificationName:kRecentPhotosNotificationKey
                                                 andDataKey:kDescriptionsKey];
  }
  else {
    return nil;
  }
}

@end

NS_ASSUME_NONNULL_END
