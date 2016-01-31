//
//  PlacesVC.m
//  Flickr Browsing
//
//  Created by Ofer Mano on 14/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import "LTPlacesVC.h"

#import "LTPlacesCollection.h"
#import "LTCityPhotosLoader.h"
#import "LTFlickrPlacesLoader.h"
#import "LTSplitViewDelegate.h"
#import "LTDescriptionsTable.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTPlacesVC()

/// The places needs to be displayed
@property (strong,nonatomic) LTPlacesCollection *places;

/// The loader of the places.
@property (strong, nonatomic) LTFlickrPlacesLoader *placesLoader;

/// Deligation class for UISplitView
@property (strong,nonatomic) LTSplitViewDelegate *splitViewDelegate;

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
  [self.placesLoader load];
}

#pragma mark -
#pragma mark Setters and Getters
#pragma mark -

- (LTFlickrPlacesLoader *)placesLoader {
  if (!_placesLoader) {
    _placesLoader = [[LTFlickrPlacesLoader alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(placesLoaded:) name:[_placesLoader observingKey] object:_placesLoader];
  }
  return _placesLoader;
}

- (LTSplitViewDelegate *)splitViewDelegate {
  if (!_splitViewDelegate)
    _splitViewDelegate = [[LTSplitViewDelegate alloc] init];
  return _splitViewDelegate;
}

#pragma mark -
#pragma mark Load handling
#pragma mark -

- (void)placesLoaded:(NSNotification *)notification {
  self.places = [notification.userInfo valueForKey:[self.placesLoader dataKey]];
  dispatch_async(dispatch_get_main_queue(), ^{ UITableView *tableView = (UITableView *)self.view; [tableView reloadData]; [self.refreshControl endRefreshing];});
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

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
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

#pragma mark -
#pragma mark Segue handling
#pragma mark -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender {
  if (![[segue identifier] isEqualToString:@"City Segue"]) {
    return;
  }
  NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
  NSString *country = [self.places getCountryByIndex:indexPath.section];
  
  LTDescriptionsTable *cityPhotosVC = [segue destinationViewController];
  LTCityPhotosLoader *loader = cityPhotosVC.desscriptionLoader;
  loader.placeID = [self.places getPlaceIDInCountry:country withIndex:indexPath.item];
}

#pragma mark -
#pragma mark Refresh
#pragma mark -

- (IBAction)refresh:(UIRefreshControl *)sender {
  [self.refreshControl beginRefreshing];
  [self.placesLoader load];
}

@end

NS_ASSUME_NONNULL_END

