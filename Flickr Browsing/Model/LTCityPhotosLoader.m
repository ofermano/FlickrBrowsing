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

@interface LTCityPhotosLoader()

@property (strong, nonatomic, nullable) NSString *placeIDSnapshot;

@end

@implementation LTCityPhotosLoader

@synthesize notificationName = _notificationName;

@synthesize dataKey = _dataKey;

- (instancetype)initWithNotificationName:(NSString *)notificationName
                              andDataKey:(NSString *)dataKey {
  if (self = [super init]) {
    _notificationName = notificationName;
    _dataKey = dataKey;
  }
  return self;
}

// The maximal number of photos we will load.
static const NSUInteger kMaxNumberOfPohtos = 50;

- (void)load {
  if (!self.placeID) {
    return;
  }
  self.placeIDSnapshot = self.placeID;
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
  dispatch_async(queue, ^{
    NSArray<LTPhotoDescription *> *descriptions = [self backgroundLoad];
    [self notify:descriptions];
  });
}

- (NSArray<LTPhotoDescription *> *)backgroundLoad {
  NSMutableArray<LTPhotoDescription *> *descriptions = [NSMutableArray array];
  NSURL *photosURL = [FlickrFetcher URLforPhotosInPlace:self.placeIDSnapshot
                                             maxResults:kMaxNumberOfPohtos];
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

- (void)notify:(NSArray<LTPhotoDescription *> *)descriptions {
  if (![self.placeID isEqualToString:self.placeIDSnapshot]) {
    [self load];
    return;
  }
  [[NSNotificationCenter defaultCenter] postNotificationName:self.notificationName
                                                      object:self
                                                    userInfo:@{self.dataKey: descriptions}];
}

@end

NS_ASSUME_NONNULL_END
