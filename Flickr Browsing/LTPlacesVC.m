//
//  LTPlacesVC.m
//  Flickr Browsing
//
//  Created by Ofer Mano on 14/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import "LTPlacesVC.h"

#import "LTCityPhotosLoader.h"
#import "LTDescriptionsTableVC.h"
#import "LTFlickrPlacesLoader.h"
#import "LTPlacesCollection.h"
#import "LTSplitViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTPlacesVC()

/// The places needs to be displayed
@property (strong, nonatomic) LTPlacesCollection *places;

/// The loader of the places.
@property (strong, nonatomic) LTFlickrPlacesLoader *placesLoader;

/// Deligation class for UISplitView
@property (strong, nonatomic) LTSplitViewDelegate *splitViewDelegate;

/// A flag that indicates that places list is being refreshed and in this case we should not allow
/// the user to select.
@property (nonatomic) BOOL refreshing;

@end

@implementation LTPlacesVC

#pragma mark -
#pragma mark Initializers
#pragma mark -

- (void)awakeFromNib {
  [super awakeFromNib];
  self.splitViewController.delegate = self.splitViewDelegate;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.refreshing = YES;
  [self.placesLoader load];
}

#pragma mark -
#pragma mark Setters and Getters
#pragma mark -

/// The key for the places loading notification.
NSString *kPlacesNotificationKey = @"PlacesLoaded";

/// The key for the loaded places.
NSString *kPlacesKey = @"places";

- (LTFlickrPlacesLoader *)placesLoader {
  if (!_placesLoader) {
    _placesLoader = [[LTFlickrPlacesLoader alloc] initWithNotificationName:kPlacesNotificationKey
                                                                andDataKey:kPlacesKey];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(placesLoaded:)
                                                 name:kPlacesNotificationKey
                                               object:_placesLoader];
  }
  return _placesLoader;
}

- (LTSplitViewDelegate *)splitViewDelegate {
  if (!_splitViewDelegate) {
    _splitViewDelegate = [[LTSplitViewDelegate alloc] init];
  }
  return _splitViewDelegate;
}

#pragma mark -
#pragma mark Load handling
#pragma mark -

- (void)placesLoaded:(NSNotification *)notification {
  dispatch_async(dispatch_get_main_queue(), ^{
    self.places = [notification.userInfo valueForKey:[self.placesLoader dataKey]];
    UITableView *tableView = (UITableView *)self.view;
    [tableView reloadData];
    self.refreshing = NO;
    [self.refreshControl endRefreshing];
  });
}

#pragma mark -
#pragma mark Deligation of UITableViewDelegate
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)sender {
  return [self.places getNumberOfCountries];
}

- (NSInteger)tableView:(UITableView *)sender numberOfRowsInSection:(NSInteger)section {
  return [self.places getNumberOfCitiesInCountry:section];
}

- (nullable NSString *)tableView:(UITableView *)tableView
         titleForHeaderInSection:(NSInteger)section {
  return [self.places getCountryByIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)sender
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Place Cell"
                                                               forIndexPath:indexPath];
  NSString *country = [self.places getCountryByIndex:indexPath.section];
  cell.textLabel.text = [self.places getCityInCountry:country withIndex:indexPath.item];
  cell.detailTextLabel.text = [self.places getProvinceInCountry:country withIndex:indexPath.item];
  return cell;
}

#pragma mark -
#pragma mark Segue handling
#pragma mark -

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender {
  return !self.refreshing;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender {
  if (![[segue identifier] isEqualToString:@"City Segue"]) {
    return;
  }
  NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
  NSString *country = [self.places getCountryByIndex:indexPath.section];
  
  LTDescriptionsTableVC *cityPhotosVC = [segue destinationViewController];
  LTCityPhotosLoader *loader = cityPhotosVC.descriptionLoader;
  loader.placeID = [self.places getPlaceIDInCountry:country withIndex:indexPath.item];
}

#pragma mark -
#pragma mark Refresh
#pragma mark -

- (IBAction)refresh:(UIRefreshControl *)sender {
  [self.refreshControl beginRefreshing];
  self.refreshing = YES;
  [self.placesLoader load];
}

@end

NS_ASSUME_NONNULL_END
