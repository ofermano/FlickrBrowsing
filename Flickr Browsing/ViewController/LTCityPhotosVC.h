//
//  LTCityPhotosVC.h
//  Flickr Browsing
//
//  Created by Ofer Mano on 15/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LTCityPhotos.h"

/// This clsss is the controller for the CityPhotos MVC.
/// It is responsible to get the list from the model and to maintain the table view.
@interface LTCityPhotosVC : UITableViewController

@property (strong,nonatomic) LTCityPhotos *photos;

@end

