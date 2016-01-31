// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Ofer Mano.

#import "LTDescriptionsTable.h"

#import "UISplitViewController+LTVirtualDetail.h"
#import "LTDescriptionLoaderFactory.h"
#import "LTPhotoVC.h"

NS_ASSUME_NONNULL_BEGIN

@implementation LTDescriptionsTable

#pragma mark -
#pragma mark Initialization
#pragma mark -

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.desscriptionLoader load];
}

#pragma mark -
#pragma mark Setters and getters
#pragma mark -

- (id<LTBackgroundLoaderProtocol>)desscriptionLoader {
  if (!_desscriptionLoader) {
    _desscriptionLoader = [LTDescriptionLoaderFactory allocateDescriptionLoader:self.restorationIdentifier];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(descriptionLoaded:) name:[_desscriptionLoader observingKey] object:_desscriptionLoader];
  }
  return _desscriptionLoader;
}

- (LTRecentPhotos *)recentPhotos {
  if (!_recentPhotos) {
    _recentPhotos = [[LTRecentPhotos alloc] init];
  }
  return _recentPhotos;
}

#pragma mark -
#pragma mark Handling description loading
#pragma mark -

- (void)descriptionLoaded:(NSNotification *)notification {
  self.descriptions = [notification.userInfo valueForKey:[self.desscriptionLoader dataKey]];
  dispatch_async(dispatch_get_main_queue(), ^{ UITableView *tableView = (UITableView *)self.view; [tableView reloadData]; [self.refreshControl endRefreshing];});
}

#pragma mark -
#pragma mark UITableView delegation
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)sender {
  return 1;
}

- (NSInteger)tableView:(UITableView *)sender numberOfRowsInSection:(NSInteger)section {
  return [self.descriptions count];
}

- (UITableViewCell *)tableView:(UITableView *)sender
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell= [self.tableView dequeueReusableCellWithIdentifier:@"Photo Cell"
                                                              forIndexPath:indexPath];
  cell.textLabel.text = self.descriptions[indexPath.item].title;
  cell.detailTextLabel.text = self.descriptions[indexPath.item].text;
  return cell;
}

- (void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)path {
  if (self.splitViewController.collapsed) {
    return;
  }
  LTPhotoVC *photoVC = self.splitViewController.viewControllers[1];
  photoVC.photoDescription = self.descriptions[path.item];
  [self.recentPhotos push:self.descriptions[path.item]];
  
}

#pragma mark -
#pragma mark Segue handling
#pragma mark -

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier
                                  sender:(nullable id)sender {
  //  return NO;
  return self.splitViewController.collapsed;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender {
  if (![[segue identifier] isEqualToString:@"Image Segue"]) {
    return;
  }
  if (![[segue destinationViewController] isKindOfClass:[LTPhotoVC class]]) {
    return;
  }
  if (![sender isKindOfClass:[UITableViewCell class]]) {
    return;
  }
  
  NSIndexPath *path = [self.tableView indexPathForCell:sender];
  LTPhotoVC *photoVC = [segue destinationViewController];
  photoVC.photoDescription = self.descriptions[path.item];
  [self.recentPhotos push:self.descriptions[path.item]];
  self.splitViewController.virtualDetail = photoVC;
}

#pragma mark -
#pragma mark Refreshing
#pragma mark -

- (IBAction)refresh:(UIRefreshControl *)sender {
  [self.refreshControl beginRefreshing];
  [self.desscriptionLoader load];
}

@end

NS_ASSUME_NONNULL_END
