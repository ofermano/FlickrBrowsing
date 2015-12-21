//
//  LTPhotoVC.h
//  Flickr Browsing
//
//  Created by Ofer Mano on 15/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LTPhotoDescription.h"

/// This view controller is responsible for displaying a given image.
/// It is called once a photo was selected.
@interface LTPhotoVC : UIViewController

/// A pubic property so photo can be set from caller view-controller
@property (strong,nonatomic) LTPhotoDescription *photoDescription;

@end

