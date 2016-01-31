//
//  LTPhotoDescription.h
//  Flickr Browsing
//
//  Created by Ofer Mano on 15/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// A struct that holds the data required to display an image.
/// The structure implements the NSCoding protocol in order to be serialized.
@interface LTPhotoDescription : NSObject <NSCoding>

#pragma mark -
#pragma mark Initializiers
#pragma mark -

/// Initialization with the data to allow immutability
- (instancetype)initWithTitle:(nullable NSString *)title
                         text:(nullable NSString *)text
                       andURL:(nullable NSURL *)url;

#pragma mark -
#pragma mark Properties
#pragma mark -

/// The title of the photo.
@property (strong, nonatomic, readonly) NSString *title;

/// The description of the photo.
@property (strong, nonatomic, readonly) NSString *text;

/// The URL of the photo.
@property (strong, nonatomic, readonly) NSURL *url;

@end

NS_ASSUME_NONNULL_END

