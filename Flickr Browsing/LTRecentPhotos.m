//
//  LTRecentPhotos.m
//  Flickr Browsing
//
//  Created by Ofer Mano on 16/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import "LTRecentPhotos.h"

#import "LTPersistentPhotoHistory.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTRecentPhotos()
@property (strong, nonatomic, nullable) NSArray *photos;
@end

NS_ASSUME_NONNULL_END

@implementation LTRecentPhotos

- (instancetype)init {
  if (self = [super init]) {
    self.photos = [LTPersistentPhotoHistory getHistory];
  }
  return self;
}

- (void)update {
  self.photos = [LTPersistentPhotoHistory getHistory];
}

+ (void)pushPhotoDescription:(LTPhotoDescription *)photoDescription {
  [LTPersistentPhotoHistory pushPhotoDescription:photoDescription];
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

