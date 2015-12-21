//
//  LTPlaceData.h
//  Flickr Browsing
//
//  Created by Ofer Mano on 14/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import <Foundation/Foundation.h>

/// A simple struct that holds the data read from Flickr.
/// This struct should be used in order to store the read data in data structure.
@interface LTPlaceData : NSObject

@property (strong,nonatomic) NSString *country;

@property (strong,nonatomic) NSString *province;

@property (strong,nonatomic) NSString *city;

@property (strong,nonatomic) NSString *place_id;

@end

