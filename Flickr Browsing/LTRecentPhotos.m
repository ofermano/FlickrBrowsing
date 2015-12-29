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
@property (strong, nonatomic) LTPersistentUniqueStack *persistenMemory;
@property (strong, nonatomic, nullable) NSArray *photos;
@end

@implementation LTRecentPhotos

static LTRecentPhotos *recentPhotos = nil;
+ (LTRecentPhotos *)list {
  if (!recentPhotos) {
    recentPhotos = [[LTRecentPhotos alloc] init];
  }
  return recentPhotos;
}

static NSString* const kAppSuit = @"Flickr Browsing";
static NSString* const kHistoryKey = @"history";
static const int kHistoryLength = 20;

- (instancetype)init {
  if (self = [super init]) {
    _persistenMemory = [[LTPersistentUniqueStack alloc] initAppSuit:kAppSuit andKey:kHistoryKey andSize:kHistoryLength];
    self.photos = [self.persistenMemory stack];
  }
  return self;
}

- (void)update {
  self.photos = [self.persistenMemory stack];
}

- (void)push:(LTPhotoDescription *)photoDescription {
  [self.persistenMemory push:photoDescription];
  [self update];
}

- (NSUInteger)getNumberOfPhotos {
  return [self.photos count];
}

- (NSString *)getTitleByIndex:(NSUInteger)index {
  LTPhotoDescription *description = self.photos[index];
  return description.title;
}

- (LTPhotoDescription *)getDescriptionByIndex:(NSUInteger)index {
  LTPhotoDescription *description = self.photos[index];
  return description;
}


@end

NS_ASSUME_NONNULL_END


