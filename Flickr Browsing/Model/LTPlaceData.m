//
//  LTPlaceData.m
//  Flickr Browsing
//
//  Created by Ofer Mano on 14/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import "LTPlaceData.h"

@implementation LTPlaceData

- (instancetype)initWithCountry:(NSString *)country
                       province:(NSString *)province
                           city:(NSString *)city
                     andPlaceID:(NSString *)placeID {
  if (self = [super init]) {
    _country = country;
    _province = province;
    _city = city;
    _place_id = placeID;
  }
  return self;
}

@end
