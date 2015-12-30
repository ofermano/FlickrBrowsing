//
//  LTPhotoDescription.m
//  Flickr Browsing
//
//  Created by Ofer Mano on 15/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import "LTPhotoDescription.h"

NS_ASSUME_NONNULL_BEGIN

@implementation LTPhotoDescription

- (instancetype) initWithTitle:(nullable NSString *)title andURL:(nullable NSURL *)url {
  if (self = [super init]) {
    _title = title;
    _url = url;
  }
  return self;
}

- (BOOL)isEqual:(id)object {
  if (![object isKindOfClass:[LTPhotoDescription class]])
    return NO;
  LTPhotoDescription *that = (LTPhotoDescription *)object;
  return ([self.title isEqual:that.title] && [self.url isEqual:that.url]);
}

#pragma mark -
#pragma mark NSCoding protocol
#pragma mark -

- (nullable id)initWithCoder:(NSCoder *)decoder {
  if (self = [super init]) {
    _title = [decoder decodeObjectForKey:@"title"];
    _url = [decoder decodeObjectForKey:@"url"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
  [encoder encodeObject:self.title forKey:@"title"];
  [encoder encodeObject:self.url forKey:@"url"];
}

@end

NS_ASSUME_NONNULL_END

