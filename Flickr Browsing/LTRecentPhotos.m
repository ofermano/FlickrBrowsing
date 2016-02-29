//
//  LTRecentPhotos.m
//  Flickr Browsing
//
//  Created by Ofer Mano on 16/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import "LTRecentPhotos.h"

#import "LTPersistentUniqueStack.h"
#import "LTPhotoDescription.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTRecentPhotos()

/// The observing key.
@property (strong, nonatomic) NSString *notificationName;

/// The key to send the loaded data.
@property (strong, nonatomic) NSString *dataKey;

/// The persistent memory we store the recent photos list.
@property (strong, nonatomic) LTPersistentUniqueStack *persistentMemory;

@end

@implementation LTRecentPhotos

// The application key in the persistent memory.
static NSString* const kAppSuit = @"Flickr Browsing";

// The recent photos key in the persistent memory.
static NSString* const kHistoryKey = @"history";

#pragma mark -
#pragma mark Initializer
#pragma mark -

- (instancetype)initWithNotificationName:(nullable NSString *)notificationName
                              andDataKey:(nullable NSString *)dataKey {
  if (self = [super init]) {
    _notificationName = notificationName;
    _dataKey = dataKey;
    _persistentMemory = [[LTPersistentUniqueStack alloc] initAppSuit:kAppSuit
                                                              andKey:kHistoryKey
                                                             andSize:kHistoryLength];
  }
  return self;
}

#pragma mark -
#pragma mark LTBackgroundLoaderProtocol
#pragma mark -

- (void)load {
  if (!self.notificationName || !self.dataKey) {
    return;
  }
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
  dispatch_async(queue, ^{
    NSArray<LTPhotoDescription *> *descriptions = [self getPhotos];
    [self notify:descriptions];
  });
}

- (void)notify:(NSArray<LTPhotoDescription *> *)descriptions {
  [[NSNotificationCenter defaultCenter] postNotificationName:self.notificationName
                                                      object:self
                                                    userInfo:@{self.dataKey:descriptions}];
}

- (NSArray<LTPhotoDescription *> *)getPhotos {
  return (NSArray<LTPhotoDescription *> *)[self.persistentMemory stack];
}

#pragma mark -
#pragma mark Managing the recent photos
#pragma mark -

- (void)push:(LTPhotoDescription *)photoDescription {
  [self.persistentMemory push:photoDescription];
}

@end

NS_ASSUME_NONNULL_END
