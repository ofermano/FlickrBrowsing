//
//  PlacesVC.m
//  Flickr Browsing
//
//  Created by Ofer Mano on 14/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import "LTPlacesVC.h"

#import "LTCityPhotos.h"
#import "LTFlickrPlaces.h"
#import "LTCityPhotosVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTPlacesVC() <UISplitViewControllerDelegate>
@property (strong, nonatomic, nullable) LTFlickrPlaces *places;
@property (assign) id <UISplitViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END

@implementation LTPlacesVC

#pragma mark -
#pragma mark Delegate split view controller
#pragma mark -
- (void)awakeFromNib {
  [super awakeFromNib];
  self.splitViewController.delegate = self;
}

- (BOOL)splitViewController:(UISplitViewController *)sender
  shouldHideViewController:(UIViewController *)master
             inOrientation:(UIInterfaceOrientation)orientation {
  return NO; // never hide it
}

#pragma mark -
#pragma mark Setters and Getters
#pragma mark -
- (LTFlickrPlaces *)places {
  if (!_places) {
    _places = [[LTFlickrPlaces alloc] init];
  }
  return _places;
}

#pragma mark -
#pragma mark Deligation of table view
#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)sender {
  return [self.places getNumberOfCountries];
}

- (NSInteger)tableView:(UITableView *)sender numberOfRowsInSection:(NSInteger)section {
  return [self.places getNumberOfCitiesInCountry:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return [self.places getCountryByIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)sender
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell;
  cell = [self.tableView dequeueReusableCellWithIdentifier:@"Place Cell" forIndexPath:indexPath];
  NSString *country = [self.places getCountryByIndex:indexPath.section];
  cell.textLabel.text = [self.places getCityInCountry:country withIndex:indexPath.item];
  cell.detailTextLabel.text = [self.places getProvinceInCountry:country withIndex:indexPath.item];
  return cell;
}

- (IBAction)refresh:(UIRefreshControl *)sender {
  [self.refreshControl beginRefreshing];
  dispatch_queue_t queue = dispatch_queue_create("RefresQueue", NULL);
  dispatch_async(queue, ^{
    self.places = [[LTFlickrPlaces alloc] init];
    dispatch_async(dispatch_get_main_queue(), ^{[self.refreshControl endRefreshing];});
  });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if (![[segue identifier] isEqualToString:@"City Segue"]) {
    return;
  }
  UIViewController *viewController = [segue destinationViewController];
  if (![viewController isKindOfClass:[LTCityPhotosVC class]]) {
    return;
  }
  NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
  NSString *country = [self.places getCountryByIndex:indexPath.section];
  LTCityPhotos *images = [self.places getImagesInCountry:country withIndex:indexPath.item];
  LTCityPhotosVC *photosVC = [segue destinationViewController];
  photosVC.photos = images;
}

@end

