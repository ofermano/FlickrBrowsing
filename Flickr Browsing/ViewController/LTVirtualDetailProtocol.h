// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Ofer Mano.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// A protocol added for splitViewController to allow a virtual detail view.
///
/// A virtual detail is when adding a view controller using a segue when splitViewController is
/// collapsed and we'd like this view controller to be in the detail view when we have split view.
///
/// This protocol is implemented by a UISplitViewController delegate class and exand the
/// UISplitViewController interface tio support virtual detail.
@protocol LTVirtualDetailProtocol <NSObject>

/// The ViewController that will be removed from the main view and will be moved to the detailed
/// view when a detail view is available.
@property (strong, nonatomic, nullable) UIViewController<LTDetailViewProtocol> *virtualDetail;

@end

NS_ASSUME_NONNULL_END
