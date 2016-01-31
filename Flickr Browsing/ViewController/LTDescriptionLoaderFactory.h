// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Ofer Mano.

#import <foundation/foundation.h>

#import "LTBackgroundLoaderProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/// A factory to create the different descriptions loaders.
@interface LTDescriptionLoaderFactory : NSObject

/// Creating the description loader given its name.
+ (id<LTBackgroundLoaderProtocol>)allocateDescriptionLoader:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
