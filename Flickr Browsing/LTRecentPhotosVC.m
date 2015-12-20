//
//  LTRecentPhotosVC.m
//  Flickr Browsing
//
//  Created by Ofer Mano on 16/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import "LTRecentPhotosVC.h"

#import "LTRecentPhotos.h"
#import "LTPhotoVC.h"


@interface LTRecentPhotosVC()
@property (strong,nonatomic) LTRecentPhotos *photos;
@end


#pragma mark -i Initialization

@implementation LTRecentPhotosVC

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.photos update];
  UITableView *tableView = (UITableView *)self.view;
  [tableView reloadData];
}


#pragma mark -i Setters and Getters

- (LTRecentPhotos *)photos {
  if (!_photos)
    _photos = [[LTRecentPhotos alloc]init];
  return _photos;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)sender {
  return 1;
}


#pragma mark -i UITableView delegation

- (NSInteger)tableView:(UITableView *)sender numberOfRowsInSection:(NSInteger)section {
  return [self.photos getNumberOfPhotos];
}

- (UITableViewCell *)tableView:(UITableView *)sender
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell;
  cell = [self.tableView dequeueReusableCellWithIdentifier:@"Recent Photo Cell" forIndexPath:indexPath];
  cell.textLabel.text = [self.photos getTitleByIndex:indexPath.item];
  return cell;
}

- (void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)path
{
  if (self.splitViewController.collapsed)
    return;
  LTPhotoVC *photoVC = self.splitViewController.viewControllers[1];
  [self callImageViewController:photoVC withIndex:path];
}


#pragma mark -i Segue handling
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier
                                  sender:(id)sender {
  return self.splitViewController.collapsed;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if (![[segue identifier] isEqualToString:@"Image Segue"])
    return;
  if (![[segue destinationViewController] isKindOfClass:[LTPhotoVC class]])
    return;
  if (![sender isKindOfClass:[UITableViewCell class]])
    return;
  
  NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
  LTPhotoVC *photoVC = [segue destinationViewController];
  [self callImageViewController:photoVC withIndex:indexPath];
}

- (void)callImageViewController:(LTPhotoVC *)photoVC withIndex:(NSIndexPath *)path {
  LTPhotoDescription *description = [self.photos getDescriptionByIndex:path.item];
  [LTRecentPhotos pushPhotoDescription:description];
  photoVC.photoDescription = description;
}

@end

