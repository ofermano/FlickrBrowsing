//
//  LTCityPhotosVC.h
//  Flickr Browsing
//
//  Created by Ofer Mano on 15/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LTCityPhotos.h"

NS_ASSUME_NONNULL_BEGIN

/// This clsss is the controller for the CityPhotos MVC.
/// It is responsible to get the list from the model and to maintain the table view.
@interface LTCityPhotosVC : UITableViewController

/// The model of the CityPhotos \c LTCityPhotos.
@property (strong, nonatomic, nullable) LTCityPhotos *photos;

@end

NS_ASSUME_NONNULL_END

