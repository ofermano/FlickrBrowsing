  //
//  LTPhotoVC.m
//  Flickr Browsing
//
//  Created by Ofer Mano on 15/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import "LTPhotoVC.h"

#import "LTImageLoader.h"


NS_ASSUME_NONNULL_BEGIN

@interface LTPhotoVC () <UIScrollViewDelegate>

/// The class that loads the image in the background.
@property (strong,nonatomic) LTImageLoader *imageLoader;

/// The scroll view that holds the image.
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

/// The image view (in the scroll view) that holds the image.
@property (strong, nonatomic) UIImageView *imageView;

/// The image we display.
@property (strong, nonatomic, nullable) UIImage *image;

/// A spinner to indicates loading is in progress.
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation LTPhotoVC

#pragma mark -
#pragma mark Restoration functions.
#pragma mark -

- (void)setRestoreData:(id)restoreData {
  if (![restoreData isKindOfClass:[UIImage class]])
    return;
  UIImage *imageToRestore = (UIImage *)restoreData;
  self.image = imageToRestore;
}

- (id)restoreData {
  return self.image;
}

#pragma mark -
#pragma mark Initialization
#pragma mark -

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.scrollView addSubview:self.imageView];
  
  // If the view is loaded in a split view controller we need to turn off animation upon loading.
  if (!self.photoDescription) {
    [self.spinner stopAnimating];
  }
}

// After each layout change we will reset the image size to match the new window size.
- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  self.scrollView.contentInset = UIEdgeInsetsZero;
  [self imageFitToFrame];
}

#pragma mark -
#pragma mark Setters and Getters
#pragma mark -

- (LTImageLoader *)imageLoader {
  if (!_imageLoader) {
    _imageLoader = [[LTImageLoader alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(imageLoaded:)
                                                 name:[_imageLoader observingKey]
                                               object:_imageLoader];

  }
  return _imageLoader;
}

- (void)setPhotoDescription:(LTPhotoDescription *)photoDescription {
  _photoDescription = photoDescription;
  self.title = photoDescription.title;
  [self startDownloadingImage];
}

- (void)setScrollView:(UIScrollView *)scrollView {
  _scrollView = scrollView;
  _scrollView.delegate = self;
}

- (UIImageView *)imageView {
  if (!_imageView) {
    _imageView = [[UIImageView alloc]init];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
  }
  return _imageView;
}

// Image is not an actual property we just propagate to image view.
- (nullable UIImage *)image {
  return self.imageView.image;
}

- (void)setImage:(nullable UIImage *)image {
  if (!image) {
    return;
  }
  self.imageView.image = image;
  CGFloat imageViewScale = [self calculateScaleToImage:self.scrollView.frame.size];
  CGRect imageViewRect = [self calculateImageViewSize:imageViewScale];
  [UIView transitionWithView:self.imageView
                    duration:0.5f
                     options:UIViewAnimationOptionTransitionFlipFromLeft
                  animations:^{ self.imageView.frame = imageViewRect;}
                  completion:^(BOOL fin){[self resetScrollViewSize:imageViewScale];[self.spinner stopAnimating];}];
  
}

#pragma mark -
#pragma mark ScrollView deligation
#pragma mark -

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
  return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView
                       withView:(nullable UIView *)view
                        atScale:(CGFloat)scale {
  CGFloat imageScale = [self calculateScaleToImage:self.imageView.frame.size];
  self.imageView.frame = [self calculateImageViewSize:imageScale];
  self.scrollView.contentSize = self.imageView.frame.size;
}

#pragma mark -
#pragma mark Image loading
#pragma mark -

- (void)startDownloadingImage {
  self.image = nil;
  if (!self.photoDescription) {
    return;
  }
  [self.spinner startAnimating];
  self.imageLoader.url = self.photoDescription.url;
  [self.imageLoader load];
}

- (void)imageLoaded:(NSNotification *)notification {
  UIImage *image = [notification.userInfo valueForKey:[self.imageLoader dataKey]];
  self.restoreData = image;
}

#pragma mark -
#pragma mark Size handling
#pragma mark -

- (IBAction)resetSize:(UITapGestureRecognizer *)sender {
  [self imageFitToFrame];
}

- (void)imageFitToFrame {
  CGFloat imageViewScale = [self calculateScaleToImage:self.scrollView.frame.size];
  CGRect imageViewRect = [self calculateImageViewSize:imageViewScale];
  self.imageView.transform = CGAffineTransformIdentity;
  self.imageView.frame = imageViewRect;
  [self resetScrollViewSize:imageViewScale];
}

- (CGFloat)calculateScaleToImage:(CGSize)size {
  CGFloat widthRatio = self.image.size.width / size.width;
  CGFloat heightRatio = self.image.size.height / size.height;
  return MAX(widthRatio,heightRatio);
}

- (CGRect)calculateImageViewSize:(CGFloat)scale {
  CGRect  viewFrame;
  viewFrame.size = self.image.size;
  viewFrame.origin = CGPointMake(0,0);
  viewFrame.size.width /= scale;
  viewFrame.size.height /= scale;
  viewFrame.size.width = MAX(self.scrollView.frame.size.width, viewFrame.size.width);
  viewFrame.size.height = MAX(self.scrollView.frame.size.height, viewFrame.size.height);
  return viewFrame;
}

- (void)resetScrollViewSize:(CGFloat)imageViewScale {
  self.scrollView.contentSize = self.imageView.frame.size;
  self.scrollView.contentOffset = CGPointMake(0,0);

  // Since we start that image fits the window there is no reson to scale down
  self.scrollView.minimumZoomScale = 1.0;
  self.scrollView.maximumZoomScale = imageViewScale;
}

@end

NS_ASSUME_NONNULL_END
