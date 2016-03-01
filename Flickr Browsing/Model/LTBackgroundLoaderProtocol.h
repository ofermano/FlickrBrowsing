// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Ofer Mano.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// A protocol for background loading.
@protocol LTBackgroundLoaderProtocol <NSObject>

/// Initialises the loader with the completion notification keys.
- (instancetype)initWithNotificationName:(NSString *)notificationName
                              andDataKey:(NSString *)dataKey;

/// Loading the data, a notification with name \c self.notificationName (see above) will be issued
/// upon completion.
- (void)load;

/// The observing key in \c NSNotificationCenter that will be issued upon completion.
@property (readonly, nonatomic) NSString *notificationName;

/// The key for the loaded data in the completion notification.
@property (readonly, nonatomic) NSString *dataKey;

@end

NS_ASSUME_NONNULL_END
