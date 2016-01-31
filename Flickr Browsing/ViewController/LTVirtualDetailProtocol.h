// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Ofer Mano.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// A protocol added for splitView to allow a virtual detail view (when working in segue).
@protocol LTVirtualDetailProtocol <NSObject>

/// The view that sould be used as detailed.
@property (strong,nonatomic,nullable) UIViewController<LTDetailViewProtocol> *virtualDetail;

@end

NS_ASSUME_NONNULL_END
