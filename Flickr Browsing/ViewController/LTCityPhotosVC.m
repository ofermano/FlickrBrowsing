//
//  LTCityPhotosVC.m
//  Flickr Browsing
//
//  Created by Ofer Mano on 15/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import "LTCityPhotosVC.h"

#import "LTRecentPhotos.h"
#import "LTPhotoVC.h"

@implementation LTCityPhotosVC

#pragma mark -
#pragma mark Deligation of table view
#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)sender {
  return 1;
}

- (NSInteger)tableView:(UITableView *)sender numberOfRowsInSection:(NSInteger)section {
  return [self.photos getNumberOfPhotos];
}

- (UITableViewCell *)tableView:(UITableView *)sender
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell= [self.tableView dequeueReusableCellWithIdentifier:@"Photo Cell"
                                                              forIndexPath:indexPath];
  NSString *photoTitle = [self.photos getTitleByIndex:indexPath.item];
  NSString *photoDescription = [self.photos getDescriptionByIndex:indexPath.item];
  if ([photoTitle length] > 0) {
    cell.textLabel.text = photoTitle;
    cell.detailTextLabel.text = photoDescription;
  }
  if ([photoTitle length] == 0 && [photoDescription length] > 0) {
      cell.textLabel.text = photoDescription;
      cell.detailTextLabel.text = nil;
  }
  if ([photoTitle length] == 0 && [photoDescription length] == 0) {
      cell.textLabel.text = @"UNKNOWN";
      cell.detailTextLabel.text = nil;
  }
  return cell;
}

- (void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)path {
  if (self.splitViewController.collapsed) {
    return;
  }
  LTPhotoVC *photoVC = self.splitViewController.viewControllers[1];
  UITableViewCell *cell = [sender cellForRowAtIndexPath:path];
  [self callImageViewController:photoVC
                      withTitle:cell.textLabel.text
                        withURL:[self.photos getImageURLByIndex:path.item]];
}

- (IBAction)refresh:(UIRefreshControl *)sender {
  [self.refreshControl beginRefreshing];
  dispatch_queue_t queue = dispatch_queue_create("RefresQueue", NULL);
  dispatch_async(queue, ^{
    [self.photos loadPhotos];
    dispatch_async(dispatch_get_main_queue(), ^{ [self.refreshControl endRefreshing];});
  });
}

#pragma mark -
#pragma mark Moving to Photo view controller
#pragma mark -
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier
                                  sender:(id)sender {
  return self.splitViewController.collapsed;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
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
  UITableViewCell *cell = (UITableViewCell *)sender;
  [self callImageViewController:photoVC
                      withTitle:cell.textLabel.text
                        withURL:[self.photos getImageURLByIndex:path.item]];
}

- (void)callImageViewController:(LTPhotoVC *)photoVC
                      withTitle:(NSString *)title
                        withURL:(NSURL *)imageURL {
  if (!imageURL) {
    return;
  }
  LTPhotoDescription *description = [[LTPhotoDescription alloc]initWith:title withURL:imageURL];
  photoVC.photoDescription = description;
  [LTRecentPhotos pushPhotoDescription:description];
}

@end

