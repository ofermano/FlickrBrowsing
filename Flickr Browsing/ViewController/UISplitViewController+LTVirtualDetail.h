// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Ofer Mano.

#import <UIKit/UIKit.h>

#import "LTDetailViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/// A category to UISplitView that adds an interface of virtual detail.
@interface UISplitViewController (LTVirtualDetail)

/// The virtual detail.
@property (strong,nonatomic) UIViewController<LTDetailViewProtocol> *virtualDetail;

@end

NS_ASSUME_NONNULL_END
