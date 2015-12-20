//
//  LTRecentPhotos.m
//  Flickr Browsing
//
//  Created by Ofer Mano on 16/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import "LTRecentPhotos.h"

#import "LTPersistentPhotoHistory.h"

@interface LTRecentPhotos()
@property (strong,nonatomic) NSArray *photos;
@end

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
  [LTPersistentPhotoHistory addPhotoDescription:photoDescription];
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

