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

/// The persistent memory we store the recent photos list.
@property (strong, nonatomic) LTPersistentUniqueStack *persistentMemory;

@end

@implementation LTRecentPhotos

@synthesize notificationName = _notificationName;

@synthesize dataKey = _dataKey;

// The application key in the persistent memory.
static const char kAppSuit[] = "Flickr Browsing";

// The recent photos key in the persistent memory.
static const char kHistoryKey[] = "history";

#pragma mark -
#pragma mark Initializer
#pragma mark -

- (instancetype)initWithNotificationName:(NSString *)notificationName
                              andDataKey:(NSString *)dataKey {
  if (self = [super init]) {
    _notificationName = notificationName;
    _dataKey = dataKey;
    NSString *appSuit = [NSString stringWithUTF8String:kAppSuit];
    NSString *historyKey = [NSString stringWithUTF8String:kHistoryKey];

    _persistentMemory = [[LTPersistentUniqueStack alloc] initAppSuit:appSuit
                                                              andKey:historyKey
                                                             andSize:kHistoryLength];
  }
  return self;
}

- (instancetype)init {
  if (self = [super init]) {
    NSString *appSuit = [NSString stringWithUTF8String:kAppSuit];
    NSString *historyKey = [NSString stringWithUTF8String:kHistoryKey];
    
    _persistentMemory = [[LTPersistentUniqueStack alloc] initAppSuit:appSuit
                                                              andKey:historyKey
                                                             andSize:kHistoryLength];
  }
  return self;
}

#pragma mark -
#pragma mark LTBackgroundLoaderProtocol
#pragma mark -

- (void)load {
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
  dispatch_async(queue, ^{
    NSArray<LTPhotoDescription *> *descriptions = [self getPhotos];
    [self notify:descriptions];
  });
}

- (void)notify:(NSArray<LTPhotoDescription *> *)descriptions {
  [[NSNotificationCenter defaultCenter] postNotificationName:self.notificationName
                                                      object:self
                                                    userInfo:@{self.dataKey: descriptions}];
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
