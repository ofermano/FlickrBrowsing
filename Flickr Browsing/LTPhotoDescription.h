//
//  LTPhotoDescription.h
//  Flickr Browsing
//
//  Created by Ofer Mano on 15/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import <Foundation/Foundation.h>

/// A struct that holds the data required for re-display a chosen image (title and URL).
/// The structure is used in order to log the user selections.
@interface LTPhotoDescription : NSObject

- (instancetype) initWith:(NSString *)title withURL:(NSURL *)url;


/// Since we can store in \c NSUserDefaults only native types we will use serialization of the stcruture to \c NSString.
+ (NSString *)serialize:(LTPhotoDescription *)description;

+ (LTPhotoDescription *)desirialize:(NSString *)descriptionString;


@property (strong,nonatomic) NSString *title;

@property (strong,nonatomic) NSURL *url;

@end

