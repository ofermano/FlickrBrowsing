// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Ofer Mano.

#import <UIKit/UIKit.h>

#import "LTBackgroundLoaderProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/// A class that loads an image in the background.
@interface LTImageLoader : NSObject <LTBackgroundLoaderProtocol>

/// The URL to load the image from.
@property (strong, nonatomic) NSURL *url;

@end

NS_ASSUME_NONNULL_END
