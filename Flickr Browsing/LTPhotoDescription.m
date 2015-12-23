//
//  LTPhotoDescription.m
//  Flickr Browsing
//
//  Created by Ofer Mano on 15/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import "LTPhotoDescription.h"

@implementation LTPhotoDescription

- (instancetype) initWith:(NSString *)title withURL:(NSURL *)url {
  if (self = [super init]) {
    self.title = title;
    self.url = url;
  }
  return self;
}

/// The assumption is the URL does not contains a space if we will first write the URL followed
/// by the space we could use the space a a separator regardless of the characters in the title.
+ (NSString *)serialize:(LTPhotoDescription *)description {
  if(!description) {
    return nil;
  }
  return [NSString stringWithFormat:@"%@ %@", [description.url absoluteString], description.title];
}

+ (LTPhotoDescription *)desirialize:(NSString *)descriptionString {
  if(!descriptionString) {
    return nil;
  }
  LTPhotoDescription *description = [[LTPhotoDescription alloc]init];
  NSArray *spaceSepsrated = [descriptionString componentsSeparatedByString:@" "];
  description.url = [NSURL URLWithString:spaceSepsrated[0]];
  if ([spaceSepsrated count] == 1) {
    description.title = @"";
  }
  else {
    NSRange titleRange = NSMakeRange(1,[spaceSepsrated count]-1);
    NSArray *titleComponents = [spaceSepsrated subarrayWithRange:titleRange];
    description.title = [titleComponents componentsJoinedByString:@" "];
  }
  return description;
}

@end

