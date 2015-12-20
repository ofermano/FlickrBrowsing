//
//  LTPhotoVC.m
//  Flickr Browsing
//
//  Created by Ofer Mano on 15/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import "LTPhotoVC.h"

@interface LTPhotoVC () <UIScrollViewDelegate>
@property (strong,nonatomic) NSURL *imageURL;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong,nonatomic) UIImageView *imageView;
@property (strong,nonatomic) UIImage *image;
@end

@implementation LTPhotoVC

#pragma -i Initialization
- (void)viewDidLoad {
  [super viewDidLoad];
  [self.scrollView addSubview:self.imageView];
  
  // If the view is loaded in a split view controller we need to turn off animation upon loading.
  if (!self.imageURL)
    [self.spinner stopAnimating];
}

// After each layout change we will reset the image size to match the new window size.
- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  [self fitImageToWindow];
}


#pragma -i Setters and Getters

// The title is a propoerty of a super class thus we need to create a new instant of \c PhotoDescription every access.
- (LTPhotoDescription *)photoDescription {
  LTPhotoDescription *description = [[LTPhotoDescription alloc] init];
  description.url = self.imageURL;
  description.title = self.title;
  return description;
}

- (void)setPhotoDescription:(LTPhotoDescription *)photoDescription {
  self.imageURL = photoDescription.url;
  self.title = photoDescription.title;
}

- (void)setImageURL:(NSURL *)imageURL {
  _imageURL = imageURL;
  [self startDownloadingImage];
}

- (void)setScrollView:(UIScrollView *)scrollView {
  _scrollView = scrollView;
  _scrollView.delegate = self;
  self.scrollView.contentSize = self.image  ?  self.image.size : CGSizeZero;
}

- (UIImageView *)imageView {
  if (!_imageView)
    _imageView = [[UIImageView alloc]init];
  return _imageView;
}

// Image is not an actual property we just propagate to image view.
- (UIImage *)image {
  return self.imageView.image;
}

- (void)setImage:(UIImage *)image {
  if (!image)
    return;
  self.imageView.image = image;
  [self fitImageToWindow];
  [self.spinner stopAnimating]; // Once we got the image we need to stop spinner.
}



#pragma mark -i ScrollView deligation

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
  return self.imageView;
}



#pragma mark -I Handling image

- (void)startDownloadingImage {
  self.image = nil;
  if (!self.imageURL)
    return;
  [self.spinner startAnimating];
  NSURLRequest *request = [NSURLRequest requestWithURL:self.imageURL];
  NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
  NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
  NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
                                                  completionHandler:^(NSURL *file, NSURLResponse *response, NSError *error) {
    if (error)
      return;
    if (![request.URL isEqual:self.imageURL])
      return;
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:file]];
    dispatch_async(dispatch_get_main_queue(), ^{self.image = image; });
  }];
  [task resume];
}

- (void)fitImageToWindow {
  if (!self.image)
    return;
  CGFloat imageViewScale = [self calculateMaximalRatioBetweenImageAndScrollView];
  [self resetImageViewSize:imageViewScale];
  [self resetScrollViewSize:imageViewScale];
}

- (IBAction)resetSize:(UITapGestureRecognizer *)sender {
  [self resetImageViewScale];
  [self resetImageViewSize:self.scrollView.maximumZoomScale]; // The scroll view maximal zoom is the reset size.
  [self resetScrollViewSize:self.scrollView.maximumZoomScale];
}

- (CGFloat)calculateMaximalRatioBetweenImageAndScrollView {
  CGFloat widthRatio = self.image.size.width / self.scrollView.frame.size.width;
  CGFloat heightRatio = self.image.size.height / self.scrollView.frame.size.height;
  return MAX(widthRatio,heightRatio);
}

- (void)resetImageViewSize:(CGFloat)scale {
  [self.imageView sizeToFit];
  CGRect  viewFrame = self.imageView.frame;
  viewFrame.origin = CGPointMake(0,0);
  viewFrame.size.width /= scale;
  viewFrame.size.height /= scale;
  self.imageView.frame = viewFrame;
}

- (void)resetScrollViewSize:(CGFloat)imageViewScale {
  self.scrollView.contentSize = self.image.size;
  self.scrollView.contentOffset = CGPointMake(0,0); // Since whole image is in window offset should be nullified.
  self.scrollView.minimumZoomScale = 1.0; // Since we start that image fits the window there is no reson to scale down
  self.scrollView.maximumZoomScale = imageViewScale; // We can scale up to maximal image size.
}

- (void)resetImageViewScale {
  CGAffineTransform viewTransform = self.imageView.transform;
  viewTransform = CGAffineTransformMakeScale(1, 1);
  self.imageView.transform = viewTransform;
}

@end
