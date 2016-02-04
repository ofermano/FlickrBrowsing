// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Ofer Mano.

#import "LTDescriptionLoaderFactory.h"

#import "LTCityPhotosLoader.h"
#import "LTRecentPhotos.h"

NS_ASSUME_NONNULL_BEGIN

@implementation LTDescriptionLoaderFactory

+ (nullable id<LTBackgroundLoaderProtocol>)allocateDescriptionLoaderForName:(NSString *)name {
  if ([name isEqual: @"City"]) {
    return [[LTCityPhotosLoader alloc] init];
  }
  else if ([name isEqual: @"Recent"]) {
    return [[LTRecentPhotos alloc] init];
  }
  else {
    return nil;
  }
}

@end

NS_ASSUME_NONNULL_END
