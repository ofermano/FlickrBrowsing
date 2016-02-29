// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Ofer Mano.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// A protocol for background loading.
@protocol LTBackgroundLoaderProtocol <NSObject>

- (instancetype)initWithNotificationName:(nullable NSString *)notificationName
                              andDataKey:(nullable NSString *)dataKey;

/// loading the data, a notification with the "notificationName" (see above) will be issued upon
/// completion.
- (void)load;

/// The observing key.
@property (strong, nonatomic, readonly) NSString *notificationName;

/// The key to send the loaded data.
@property (strong, nonatomic, readonly) NSString *dataKey;

@end

NS_ASSUME_NONNULL_END
