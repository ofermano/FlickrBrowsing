// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Ofer Mano.

#import <UIKit/UIKit.h>

#import "LTDetailViewProtocol.h"
#import "LTVirtualDetailProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/// The delegation of the split view to add application specific (and handling moving from
/// single view to split view).
@interface LTSplitViewDelegate : NSObject <UISplitViewControllerDelegate,LTVirtualDetailProtocol>

/// The view that sould be used as detailed.
@property (strong,nonatomic,nullable) UIViewController<LTDetailViewProtocol> *virtualDetail;

@end

NS_ASSUME_NONNULL_END
