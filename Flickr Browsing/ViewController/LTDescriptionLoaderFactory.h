// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Ofer Mano.

#import <Foundation/Foundation.h>

#import "LTBackgroundLoaderProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/// A factory to create the different descriptions loaders.
@interface LTDescriptionLoaderFactory : NSObject

/// Creates the description loader given its name.
+ (id<LTBackgroundLoaderProtocol>)descriptionLoaderForName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
