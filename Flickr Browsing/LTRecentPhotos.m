//
//  LTRecentPhotos.m
//  Flickr Browsing
//
//  Created by Ofer Mano on 16/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import "LTRecentPhotos.h"

#import "LTPersistentUniqueStack.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTRecentPhotos()

/// The persistentmemory.
@property (strong, nonatomic) LTPersistentUniqueStack *persistenMemory;

@end

@implementation LTRecentPhotos

static NSString* const kAppSuit = @"Flickr Browsing";
static NSString* const kHistoryKey = @"history";

#pragma mark -
#pragma mark Initializer
#pragma mark -

- (instancetype)init {
  if (self = [super init]) {
    _persistenMemory = [[LTPersistentUniqueStack alloc] initAppSuit:kAppSuit andKey:kHistoryKey andSize:kHistoryLength];
  }
  return self;
}

#pragma mark -
#pragma mark Implementing background loading protocol
#pragma mark -

- (void)load {
  dispatch_queue_t queue = dispatch_queue_create("LoadQueue", NULL);
  dispatch_async(queue, ^{
    NSArray<LTPhotoDescription *> *descriptions = [self getPhotos];
    [self notify:descriptions];
  });
}

- (NSString *)observingKey {
  return @"RecentDescriptionsLoaded";
}

- (NSString *)dataKey {
  return @"descriptions";
}

- (void)notify:(NSArray<LTPhotoDescription *> *)desscriptions {
  [[NSNotificationCenter defaultCenter] postNotificationName:[self observingKey] object:self userInfo:@{[self dataKey]:desscriptions}];
}

- (NSArray<LTPhotoDescription *> *)getPhotos {
  return (NSArray<LTPhotoDescription *> *)[self.persistenMemory stack];
}

#pragma mark -
#pragma mark Managing the recent photos
#pragma mark -

- (void)push:(LTPhotoDescription *)photoDescription {
  [self.persistenMemory push:photoDescription];
}

@end

NS_ASSUME_NONNULL_END
