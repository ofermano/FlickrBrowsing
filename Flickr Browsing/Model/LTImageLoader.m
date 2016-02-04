// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Ofer Mano.

#import "LTImageLoader.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTImageLoader()

/// Cache for last loaded images.
@property (strong, nonatomic) NSCache *imageCache;

/// The URL session for image loading.
@property (strong, nonatomic) NSURLSession *session;

@end

@implementation LTImageLoader

// The size of the cache we store.
static const NSUInteger kCacheSize = 5;

- (NSString *)notificationName {
  return @"ImageLoaded";
}

- (NSString *)dataKey {
  return @"image";
}
- (NSCache *)imageCache {
  if (!_imageCache) {
    _imageCache = [[NSCache alloc]init];
    [_imageCache setCountLimit:kCacheSize];
  }
  return _imageCache;
}

- (NSURLSession *)session {
  if (!_session) {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:config];
  }
  return _session;
}

- (void)load {
  if ([self useCache:self.url]) {
    return;
  }
  [self backgroundLoading:self.url];
}

- (BOOL)useCache:(NSURL *)url {
  UIImage *cachedImage = [self.imageCache objectForKey:url.absoluteString];
  if (cachedImage) {
    [self notify:cachedImage];
    return YES;
  }
  return NO;
}

- (void)backgroundLoading:(NSURL *)url {
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  NSURLSessionDownloadTask *task = [self.session downloadTaskWithRequest:request
    completionHandler:^(NSURL *file, NSURLResponse *response, NSError *error) {
      if (error) {
        return;
      }
      if (![request.URL isEqual:url]) {
        return;
      }
      UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:file]];
      [self.imageCache setObject:image forKey:url.absoluteString];
      [self notify:image];
    }];
  [task resume];
}

- (void)notify:(UIImage *)image {
  [[NSNotificationCenter defaultCenter] postNotificationName:[self notificationName]
                                                      object:self
                                                    userInfo:@{[self dataKey]: image}];
}

@end

NS_ASSUME_NONNULL_END
