//
//  LTPersistentPhotoHistory.h
//  Flickr Browsing
//
//  Created by Ofer Mano on 15/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LTPhotoDescription.h"

NS_ASSUME_NONNULL_BEGIN

/// Two global functions that wrps the \c NSUserDefaults.
/// These function can be called anywhere in the code to get or add a \c PhotoDescription to the
/// application history.
@interface LTPersistentPhotoHistory : NSObject

/// Adding a photo desscription to the head of the history.
+ (void)pushPhotoDescription:(nullable LTPhotoDescription *)description;

/// Getting the history.
+ (nullable NSMutableArray *)getHistory;

@end

NS_ASSUME_NONNULL_END
