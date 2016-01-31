// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Ofer Mano.

#import "UISplitViewController+LTVirtualDetail.h"

#import "LTSplitViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@implementation UISplitViewController (LTVirtualDetail)

- (void)setVirtualDetail:(UIViewController<LTDetailViewProtocol> *)virtualDetail {
  if (![[((id)self.delegate) class] conformsToProtocol:@protocol(LTVirtualDetailProtocol)])
    return;
  id<LTVirtualDetailProtocol> virtualDetailHandler = (id<LTVirtualDetailProtocol>)self.delegate;
  virtualDetailHandler.virtualDetail = virtualDetail;
}

- (UIViewController<LTDetailViewProtocol> *)virtualDetail {
  if (![[((id)self.delegate) class] conformsToProtocol:@protocol(LTVirtualDetailProtocol)])
    return nil;
  id<LTVirtualDetailProtocol> virtualDetailHandler = (id<LTVirtualDetailProtocol>)self.delegate;
  return virtualDetailHandler.virtualDetail;
}

@end

NS_ASSUME_NONNULL_END
