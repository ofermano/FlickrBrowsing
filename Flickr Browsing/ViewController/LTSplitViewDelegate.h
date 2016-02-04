// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Ofer Mano.

#import <UIKit/UIKit.h>

#import "LTDetailViewProtocol.h"
#import "LTVirtualDetailProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/// The delegation of the split view to improve behavior when rotating a iPhone 6+ (moving from
/// detailed to collapse)
@interface LTSplitViewDelegate : NSObject <UISplitViewControllerDelegate, LTVirtualDetailProtocol>

/// A virtualDetail is a view controller that is added as when split view is collapsed and when
/// moving to a detail view it should apear in the detailed view.
@property (strong, nonatomic, nullable) UIViewController<LTDetailViewProtocol> *virtualDetail;

@end

NS_ASSUME_NONNULL_END
