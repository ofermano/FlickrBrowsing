// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Ofer Mano.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// A protocol that allows restoring a detail view moving from navigation to split view.
///
/// This protocol shoulbe be implemented by a view who wishes to act as a detailed view controller.
@protocol LTDetailViewProtocol <NSObject>

/// The data required to restore the view controller that implements that protocol.
@property (nonatomic) id restoreData;

@end

NS_ASSUME_NONNULL_END
