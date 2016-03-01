// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Ofer Mano.

#import "LTDescriptionLoaderFactory.h"

#import "LTCityPhotosLoader.h"
#import "LTRecentPhotos.h"

NS_ASSUME_NONNULL_BEGIN

@implementation LTDescriptionLoaderFactory

/// The key for recent photos loading notification.
static const char kRecentPhotosNotificationKey[] = "RecentDescriptionsLoaded";

/// The key for recent photos loading notification.
static const char kCityPhotosNotificationKey[] = "CityDescriptionsLoaded";

/// The key for the loaded recent photos.
static const char kDescriptionsKey[] = "descriptions";

+ (id<LTBackgroundLoaderProtocol>)descriptionLoaderForName:(NSString *)name {
  if ([name isEqual: @"City"]) {
    NSString *notificationName = [NSString stringWithUTF8String:kCityPhotosNotificationKey];
    NSString *dataKey = [NSString stringWithUTF8String:kDescriptionsKey];

    return [[LTCityPhotosLoader alloc] initWithNotificationName:notificationName
                                                     andDataKey:dataKey];
  }
  else if ([name isEqual: @"Recent"]) {
    NSString *notificationName = [NSString stringWithUTF8String:kRecentPhotosNotificationKey];
    NSString *dataKey = [NSString stringWithUTF8String:kDescriptionsKey];
    return [[LTRecentPhotos alloc] initWithNotificationName:notificationName
                                                 andDataKey:dataKey];
  }
  else {
    NSAssert(NO, @"Illeagal token %@", name);
    return nil;
  }
}

@end

NS_ASSUME_NONNULL_END
