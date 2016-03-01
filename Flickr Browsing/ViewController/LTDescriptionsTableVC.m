//
//  LTPlacesVC.m
//  Flickr Browsing
//
//  Created by Ofer Mano on 14/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import "LTDescriptionsTableVC.h"

#import "UISplitViewController+LTVirtualDetail.h"
#import "LTDescriptionLoaderFactory.h"
#import "LTPhotoDescription.h"
#import "LTPhotoVC.h"
#import "LTRecentPhotos.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTDescriptionsTableVC()

/// The descriptions to manage.
@property (strong, nonatomic) NSArray<LTPhotoDescription *> *descriptions;

/// The recent photos (need to push upon selection).
@property (strong, nonatomic) LTRecentPhotos *recentPhotos;

/// A flag that indicates that places list is being refreshed and in this case we should not allow
/// the user to select.
@property (nonatomic) BOOL refreshing;

@end

@implementation LTDescriptionsTableVC

#pragma mark -
#pragma mark Initialization
#pragma mark -

- (void)viewDidLoad {
  [super viewDidLoad];
  self.refreshing = YES;
  [self.descriptionLoader load];
}

#pragma mark -
#pragma mark Setters and getters
#pragma mark -

- (nullable id<LTBackgroundLoaderProtocol>)descriptionLoader {
  if (!_descriptionLoader) {
    _descriptionLoader = [LTDescriptionLoaderFactory
                          descriptionLoaderForName:self.restorationIdentifier];
    if (_descriptionLoader) {
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(descriptionLoaded:)
                                                   name:_descriptionLoader.notificationName
                                                 object:_descriptionLoader];
    }
  }
  return _descriptionLoader;
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
  dispatch_async(dispatch_get_main_queue(), ^{
    self.descriptions = [notification.userInfo valueForKey:[self.descriptionLoader dataKey]];
    UITableView *tableView = (UITableView *)self.view;
    [tableView reloadData];
    self.refreshing = NO;
    [self.refreshControl endRefreshing];
  });
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
  if (self.refreshing) {
    return;
  }
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
  if (self.refreshing) {
    return NO;
  }
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
  self.refreshing = YES;
  [self.descriptionLoader load];
}

@end

NS_ASSUME_NONNULL_END
