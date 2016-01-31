// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Ofer Mano.

#import "LTImageLoader.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTImageLoader()

/// A ditionary that maps URLs to images for caching.
@property (strong,nonatomic) NSMutableDictionary *imageCache;

/// List of the last URLs called to manage the cache.
@property (strong,nonatomic) NSMutableArray<NSString *> *lastImages;

@end

@implementation LTImageLoader

static NSUInteger kCacheSize = 5;

- (NSString *)observingKey {
  return @"ImageLoaded";
}

- (NSString *)dataKey {
  return @"image";
}

- (NSMutableDictionary *)imageCache {
  if (!_imageCache) {
    _imageCache = [[NSMutableDictionary alloc] init];
  }
  return _imageCache;
}

- (NSMutableArray<NSString *> *)lastImages {
  if (!_lastImages) {
    _lastImages = [[NSMutableArray<NSString *> alloc] init];
  }
  return _lastImages;
}

- (void)load {
  if ([self useCache:self.url]) {
    return;
  }
  [self backgroundLoading:self.url];
}

- (BOOL)useCache:(NSURL *)url {
  UIImage *cachedImage = [self.imageCache valueForKey:url.absoluteString];
  if (cachedImage) {
    [self.lastImages removeObject:url.absoluteString];
    [self.lastImages addObject:url.absoluteString];
    [self notify:cachedImage];
    return YES;
  }
  return NO;
}

- (void)backgroundLoading:(NSURL *)url {
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
  NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
  NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
    completionHandler:^(NSURL *file, NSURLResponse *response, NSError *error) {
      if (error) {
        return;
      }
      if (![request.URL isEqual:url]) {
        return;
      }
      UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:file]];
      while ([self.lastImages count] >= kCacheSize) {
        NSString *oldestURL = [self.lastImages firstObject];
        [self.lastImages removeObject:oldestURL];
        [self.imageCache removeObjectForKey:oldestURL];
      }
      [self.lastImages addObject:url.absoluteString];
      [self.imageCache setValue:image forKey:url.absoluteString];
      dispatch_async(dispatch_get_main_queue(), ^{[self notify:image]; });
    }];
  [task resume];
}

- (void)notify:(UIImage *)image {
  [[NSNotificationCenter defaultCenter] postNotificationName:[self observingKey]
                                                      object:self
                                                    userInfo:@{[self dataKey]:image}];
}

@end

NS_ASSUME_NONNULL_END
