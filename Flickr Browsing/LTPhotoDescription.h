//
//  LTPhotoDescription.h
//  Flickr Browsing
//
//  Created by Ofer Mano on 15/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// A struct that holds the data required for re-display a chosen image (title and URL).
/// The structure implements the NSCoding protocol in order to be serialized.
@interface LTPhotoDescription : NSObject <NSCoding>

#pragma mark -
#pragma mark Initializiers
#pragma mark -

/// Initialization with the data.
- (instancetype)initWithTitle:(nullable NSString *)title andURL:(nullable NSURL *)url;

#pragma mark -
#pragma mark Properties
#pragma mark -

/// The title of the photo.
@property (strong, nonatomic, readonly) NSString *title;

/// The URL of the photo.
@property (strong, nonatomic, readonly) NSURL *url;

@end

NS_ASSUME_NONNULL_END

