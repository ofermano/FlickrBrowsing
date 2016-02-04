// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Ofer Mano.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// A protocol for background loading.
@protocol LTBackgroundLoaderProtocol <NSObject>

/// Getting the observing key.
- (NSString *)notificationName;

/// The key to get the loaded data.
- (NSString *)dataKey;

/// loading the data, a notification with the "notificationName" (see above) will be issued upon
/// completion.
- (void)load;

@end

NS_ASSUME_NONNULL_END
