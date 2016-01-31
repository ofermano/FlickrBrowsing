// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Ofer Mano.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// A protocol to allow restoring a detail view moving from navigation to split view.
@protocol LTDetailViewProtocol <NSObject>

/// The data required for restore/
@property (nonatomic) id restoreData;

@end

NS_ASSUME_NONNULL_END
