//
//  LTCityPhotos.m
//  Flickr Browsing
//
//  Created by Ofer Mano on 14/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import "LTCityPhotos.h"

#import "FlickrFetcher.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTCityPhotos()
@property (strong, nonatomic, nullable) NSArray *photos;
@property (strong, nonatomic, nullable) NSString *placeID;
@end

NS_ASSUME_NONNULL_END

@implementation LTCityPhotos

static const NSUInteger kMaxNumberOfPphtos = 50;

- (instancetype)initWithPlaceID:(NSString *)placeID {
  if (self = [super init]) {
    self.placeID = placeID;
    [self loadPhotos];
  }
  return self;
}

- (void)loadPhotos {
  if (!self.placeID) {
    return;
  }
  NSURL *photosURL = [FlickrFetcher URLforPhotosInPlace:self.placeID maxResults:kMaxNumberOfPphtos];
  NSData *photosData = [NSData dataWithContentsOfURL:photosURL];
  NSDictionary *photosDictionary = [NSJSONSerialization JSONObjectWithData:photosData
                                                                   options:0
                                                                     error:nil];
  NSArray *photos = [photosDictionary valueForKeyPath:FLICKR_RESULTS_PHOTOS];
  self.photos = photos;
}

- (NSUInteger)getNumberOfPhotos {
  return [self.photos count];
}

- (NSString *)getTitleByIndex:(NSUInteger)index {
  return [self.photos[index] valueForKeyPath:FLICKR_PHOTO_TITLE];
}

- (NSString *)getDescriptionByIndex:(NSUInteger)index {
  return [self.photos[index] valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
}

- (NSURL *)getImageURLByIndex:(NSUInteger)index {
  return [FlickrFetcher URLforPhoto:self.photos[index] format:FlickrPhotoFormatOriginal];
}



@end

