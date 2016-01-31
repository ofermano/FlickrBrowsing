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

- (NSString *)observingKey {
  return @"DescriptionsLoaded";
}

- (NSString *)dataKey {
  return @"descriptions";
}

static const NSUInteger kMaxNumberOfPphtos = 50;

- (void)load {
  dispatch_queue_t queue = dispatch_queue_create("LoadQueue", NULL);
  dispatch_async(queue, ^{
    NSArray<LTPhotoDescription *> *descriptions = [self backgroundLoad];
    [self notify:descriptions];
  });
}

- (NSArray<LTPhotoDescription *> *)backgroundLoad {
  NSMutableArray<LTPhotoDescription *> * descriptoins =
    [[NSMutableArray<LTPhotoDescription *> alloc] init];
  if (!self.placeID) {
    return descriptoins;
  }
  NSURL *photosURL = [FlickrFetcher URLforPhotosInPlace:self.placeID maxResults:kMaxNumberOfPphtos];
  NSData *photosData = [NSData dataWithContentsOfURL:photosURL];
  NSDictionary *photosDictionary = [NSJSONSerialization JSONObjectWithData:photosData
                                                                   options:0
                                                                     error:nil];
  NSArray *flickrData = [photosDictionary valueForKeyPath:FLICKR_RESULTS_PHOTOS];
  
  for (NSUInteger ix = 0; ix < [flickrData count]; ix++) {
    NSURL *url = [FlickrFetcher URLforPhoto:flickrData[ix] format:FlickrPhotoFormatOriginal];
    if (!url)
      continue;
    NSString *originalTitle = [flickrData[ix] valueForKeyPath:FLICKR_PHOTO_TITLE];
    NSString *originalText = [flickrData[ix] valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
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
    [descriptoins addObject:[[LTPhotoDescription alloc] initWithTitle:title text:text andURL:url]];
  }
  return descriptoins;
}

- (void)notify:(NSArray<LTPhotoDescription *> *)desscriptions {
  [[NSNotificationCenter defaultCenter] postNotificationName:[self observingKey]
                                                      object:self
                                                    userInfo:@{[self dataKey]:desscriptions}];
}

@end

NS_ASSUME_NONNULL_END
