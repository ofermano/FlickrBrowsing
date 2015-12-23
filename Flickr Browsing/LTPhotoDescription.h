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
/// The structure is used in order to log the user selections.
@interface LTPhotoDescription : NSObject

#pragma mark -
#pragma mark Initializiers
#pragma mark -
/// Initialization with the data.
- (instancetype) initWith:(nullable NSString *)title withURL:(nullable NSURL *)url;

#pragma mark -
#pragma mark Class interface
#pragma mark -
/// Since we can store in \c NSUserDefaults only native types we will use serialization of the
/// stcruture to \c NSString.
+ (nullable NSString *)serialize:(nullable LTPhotoDescription *)description;

/// Creating a \c LTPhotoDescription from a string.
+ (nullable LTPhotoDescription *)desirialize:(nullable NSString *)descriptionString;

#pragma mark -
#pragma mark Properties
#pragma mark -
/// The title of the photo.
@property (strong, nonatomic, nullable) NSString *title;

/// The URL of the photo.
@property (strong, nonatomic, nullable) NSURL *url;

@end

NS_ASSUME_NONNULL_END

