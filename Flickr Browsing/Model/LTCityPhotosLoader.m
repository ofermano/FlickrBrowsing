//
//  LTCityPhotos.m
//  Flickr Browsing
//
//  Created by Ofer Mano on 14/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import "LTCityPhotosLoader.h"

#import "FlickrFetcher.h"
#import "LTPhotoDescription.h"

NS_ASSUME_NONNULL_BEGIN

@implementation LTCityPhotosLoader

- (NSString *)notificationName {
  return @"DescriptionsLoaded";
}

- (NSString *)dataKey {
  return @"descriptions";
}

// The maximal number of photos we will load.
static const NSUInteger kMaxNumberOfPohtos = 50;

- (void)load {
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
  dispatch_async(queue, ^{
    NSArray<LTPhotoDescription *> *descriptions = [self backgroundLoad];
    [self notify:descriptions];
  });
}

- (NSArray<LTPhotoDescription *> *)backgroundLoad {
  NSMutableArray<LTPhotoDescription *> *descriptions = [NSMutableArray array];
  if (!self.placeID) {
    return descriptions;
  }
  NSURL *photosURL = [FlickrFetcher URLforPhotosInPlace:self.placeID maxResults:kMaxNumberOfPohtos];
  NSData *photosData = [NSData dataWithContentsOfURL:photosURL];
  NSDictionary *photosDictionary = [NSJSONSerialization JSONObjectWithData:photosData
                                                                   options:0
                                                                     error:nil];
  NSArray *flickrData = [photosDictionary valueForKeyPath:FLICKR_RESULTS_PHOTOS];
  
  for (NSDictionary *photo in flickrData) {
    NSURL *url = [FlickrFetcher URLforPhoto:photo format:FlickrPhotoFormatOriginal];
    if (!url) {
      continue;
    }
    NSString *originalTitle = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
    NSString *originalText = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    NSString *title = nil;
    NSString *text = nil;

    if ([originalTitle length] > 0) {
      title = originalTitle;
      text = originalText;
    }
    if ([originalTitle length] == 0 && [originalText length] > 0) {
      title = originalText;
      text = nil;
    }
    if ([originalTitle length] == 0 && [originalText length] == 0) {
      title = @"UNKNOWN";
      text = nil;
    }
    [descriptions addObject:[[LTPhotoDescription alloc] initWithTitle:title text:text andURL:url]];
  }
  return descriptions;
}

- (void)notify:(NSArray<LTPhotoDescription *> *)desscriptions {
  [[NSNotificationCenter defaultCenter] postNotificationName:[self notificationName]
                                                      object:self
                                                    userInfo:@{[self dataKey]: desscriptions}];
}

@end

NS_ASSUME_NONNULL_END
