// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Ofer Mano.

#import "LTSplitViewDelegate.h"


NS_ASSUME_NONNULL_BEGIN

@interface LTSplitViewDelegate()

/// The story board restoration identifier of the view we'd like to restore.
@property (strong, nonatomic, nullable) NSString *viewIdentifier;

/// The data required in order to restore the detailed view.
@property (nonatomic) id restoreData;

@end

@implementation LTSplitViewDelegate

- (BOOL)splitViewController:(UISplitViewController *)sender
   shouldHideViewController:(UIViewController *)master
              inOrientation:(UIInterfaceOrientation)orientation {
  return NO;
}

// Upon expansion we pop the detailed views.
- (nullable UIViewController *)primaryViewControllerForExpandingSplitViewController:
    (UISplitViewController *)splitViewController {
  if (![splitViewController.viewControllers[0] isKindOfClass:[UITabBarController class]]) {
    return nil;
  }
  UITabBarController *tabController = splitViewController.viewControllers[0];
  for (UIViewController *vc in tabController.viewControllers) {
    if (![vc isKindOfClass:[UINavigationController class]]) {
      continue;
    }
    UINavigationController *navigation = (UINavigationController *)vc;
    UIViewController *visible = navigation.visibleViewController;
    if (![[visible class] conformsToProtocol:@protocol(LTDetailViewProtocol)]) {
      continue;
    }
    [navigation popViewControllerAnimated:NO];
  }
  return tabController;
}

// Upon expansion we create and restore the virtual detail view.
- (nullable UIViewController *)splitViewController:(UISplitViewController *)splitViewController
separateSecondaryViewControllerFromPrimaryViewController:(UIViewController *)primaryViewController {
  if (!self.virtualDetail) {
    return nil;
  }
  UIViewController *newVC =
    [splitViewController.storyboard instantiateViewControllerWithIdentifier:self.viewIdentifier];
  if (![[newVC class] conformsToProtocol:@protocol(LTDetailViewProtocol)]) {
    return nil;
  }
  UIViewController<LTDetailViewProtocol> *newDetailedVC =
    (UIViewController<LTDetailViewProtocol> *)newVC;
  newDetailedVC.restoreData = self.restoreData;
  self.virtualDetail = nil;
  return newVC;
}

- (void)setVirtualDetail:(nullable UIViewController<LTDetailViewProtocol> *)virtualDetail {
  if (_virtualDetail) {
    [_virtualDetail removeObserver:self forKeyPath:NSStringFromSelector(@selector(restoreData))];
  }
  _virtualDetail = virtualDetail;
  self.viewIdentifier = virtualDetail.restorationIdentifier;
  [virtualDetail addObserver:self forKeyPath:NSStringFromSelector(@selector(restoreData))
                     options:NSKeyValueObservingOptionNew
                     context:NULL];
}

// Getting notfication from the detail view when restore data changes in order to restore later.
- (void)observeValueForKeyPath:(nullable NSString *)keyPath
                      ofObject:(nullable id)object
                        change:(nullable NSDictionary *)change
                       context:(nullable void *)context {
  
  if ([keyPath isEqual:NSStringFromSelector(@selector(restoreData))]) {
    self.restoreData = [change objectForKey:NSKeyValueChangeNewKey];
  }
}

@end

NS_ASSUME_NONNULL_END
