//
//  MerryPhotoViewController.m
//  MerryPhotoViewer
//
//  Created by bang on 19/07/2017.
//  Copyright © 2017 MerryJS. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MerryPhoto.h"
#import "MerryPhotoViewer.h"

typedef NS_ENUM(NSUInteger, NYTViewControllerPhotoIndex) {
  NYTViewControllerPhotoIndexCustomEverything = 1,
  NYTViewControllerPhotoIndexLongCaption = 2,
  NYTViewControllerPhotoIndexDefaultLoadingSpinner = 3,
  NYTViewControllerPhotoIndexNoReferenceView = 4,
  NYTViewControllerPhotoIndexCustomMaxZoomScale = 5,
  NYTViewControllerPhotoIndexGif = 6,
  NYTViewControllerPhotoCount,
};

@implementation MerryPhotoViewer

// tell React we want export this module
RCT_EXPORT_MODULE();

- (instancetype)init {
  if (self = [super init]) {
    self.options = @{ @"X" : @NO };
  }
  return self;
}

/**
  declaring we want to auto generate some getters and setters for our bridge.
 */
@synthesize bridge = _bridge;

/**
 Set options

 @param options <#options description#>
 @param resolve <#resolve description#>
 @param reject <#reject description#>
 */
- (void)setConfiguration:(NSDictionary *)options
                resolver:(RCTPromiseResolveBlock)resolve
                rejecter:(RCTPromiseRejectBlock)reject {
  self.resolve = resolve;
  self.reject = reject;
  self.options = [NSMutableDictionary dictionaryWithDictionary:self.options];
  for (NSString *key in options.keyEnumerator) {
    [self.options setValue:options[key] forKey:key];
  }
}

/// A second set of test photos, to demonstrate reloading the entire data source.
+ (NYTPhotoViewerArrayDataSource *)newVariedDataSourceIncludingPhoto:(MerryPhoto *)photo {
  NSMutableArray *photos = [NSMutableArray array];

  [photos addObject:({
            MerryPhoto *p = [MerryPhoto new];
            p.image = [UIImage imageNamed:@"Chess"];
            p.attributedCaptionTitle = [self attributedTitleFromString:@"Chess"];
            p.attributedCaptionCredit = [self attributedCreditFromString:@"Photo: Chris Dzombak"];
            p;
          })];

  [photos
      addObject:({
        MerryPhoto *p = photo;
        photo.attributedCaptionTitle = nil;
        p.attributedCaptionSummary = [self
            attributedSummaryFromString:@"This photo’s caption has changed in the data source."];
        p;
      })];

  return [NYTPhotoViewerArrayDataSource dataSourceWithPhotos:photos];
}

+ (NSAttributedString *)attributedTitleFromString:(NSString *)caption {
  return [[NSAttributedString alloc]
      initWithString:caption
          attributes:@{
            NSForegroundColorAttributeName : [UIColor whiteColor],
            NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody]
          }];
}

+ (NSAttributedString *)attributedSummaryFromString:(NSString *)summary {
  return [[NSAttributedString alloc]
      initWithString:summary
          attributes:@{
            NSForegroundColorAttributeName : [UIColor lightGrayColor],
            NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody]
          }];
}

+ (NSAttributedString *)attributedCreditFromString:(NSString *)credit {
  return [[NSAttributedString alloc]
      initWithString:credit
          attributes:@{
            NSForegroundColorAttributeName : [UIColor grayColor],
            NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1]
          }];
}

/**
 Get root view

 @param rootViewController <#rootViewController description#>
 @return presented View
 */
- (UIViewController *)visibleViewController:(UIViewController *)rootViewController {
  if (rootViewController.presentedViewController == nil) {
    return rootViewController;
  }
  if ([rootViewController.presentedViewController isKindOfClass:[UINavigationController class]]) {
    UINavigationController *navigationController =
        (UINavigationController *)rootViewController.presentedViewController;
    UIViewController *lastViewController = [[navigationController viewControllers] lastObject];

    return [self visibleViewController:lastViewController];
  }
  if ([rootViewController.presentedViewController isKindOfClass:[UITabBarController class]]) {
    UITabBarController *tabBarController =
        (UITabBarController *)rootViewController.presentedViewController;
    UIViewController *selectedViewController = tabBarController.selectedViewController;

    return [self visibleViewController:selectedViewController];
  }

  UIViewController *presentedViewController =
      (UIViewController *)rootViewController.presentedViewController;

  return [self visibleViewController:presentedViewController];
}

/**
 download image by index

 @param index <#index description#>
 @return <#return value description#>
 */
- (UIImage *)downloadImageById:(NSInteger)index {
  NSMutableArray *photos = [self.options mutableArrayValueForKey:@"photos"];

  NSString *url = photos[index];
  UIImageView *imageView = [[UIImageView alloc] init];
  //    [imageView sd_setShowActivityIndicatorView:YES];
  //    [imageView sd_setIndicatorStyle:UIActivityIndicatorViewStyleGray];

  [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];

  return imageView.image;
}
RCT_EXPORT_METHOD(show
                  : (NSDictionary *)options resolver
                  : (RCTPromiseResolveBlock)resolve rejecter
                  : (RCTPromiseRejectBlock)reject) {
  [self setConfiguration:options resolver:resolve rejecter:reject];

  NSMutableArray *photos = [self.options mutableArrayValueForKey:@"photos"];
  NSUInteger initialPhoto = [[self.options objectForKey:@"initial"] integerValue];

  NSMutableArray *msPhotos = [NSMutableArray array];

  for (int i = 0; i < photos.count; i++) {
    MerryPhoto *merryPhoto = [MerryPhoto new];

    merryPhoto.image = nil;

    [msPhotos addObject:merryPhoto];
  }

  self.photos = msPhotos;
  self.dataSource = [NYTPhotoViewerArrayDataSource dataSourceWithPhotos:self.photos];

  dispatch_async(dispatch_get_main_queue(), ^{

    UIViewController *ctrl =
        [self visibleViewController:[UIApplication sharedApplication].keyWindow.rootViewController];

    NYTPhotosViewController *photosViewController =
        [[NYTPhotosViewController alloc] initWithDataSource:self.dataSource
                                               initialPhoto:[self.photos objectAtIndex:initialPhoto]
                                                   delegate:self];

    self.nytPhotoVC = photosViewController;

    [ctrl presentViewController:photosViewController animated:YES completion:nil];
    if (initialPhoto) {
      [self updatePhotoAtIndex:photosViewController Index:initialPhoto];
    }

  });
}

/**
 Update Photo
 @param photosViewController <#photosViewController description#>
 @param photoIndex <#photoIndex description#>
 */
- (void)updatePhotoAtIndex:(NYTPhotosViewController *)photosViewController
                     Index:(NSUInteger)photoIndex {
  NSInteger current = (unsigned long)photoIndex;
  MerryPhoto *currentPhoto = [self.dataSource.photos objectAtIndex:current];
  NSMutableArray *photos = [self.options mutableArrayValueForKey:@"photos"];

  NSString *url = photos[current];
  NSURL *imageURL = [NSURL URLWithString:url];
  dispatch_async(dispatch_get_main_queue(), ^{
    SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
    [downloader
        downloadImageWithURL:imageURL
                     options:0
                    progress:nil
                   completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                     //                       when downloads completed update photo
                     if (image && finished) {
                       currentPhoto.image = image;
                       [photosViewController updatePhoto:currentPhoto];
                     }
                   }];

  });
}

#pragma mark - NYTPhotosViewControllerDelegate

- (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController
           referenceViewForPhoto:(id<NYTPhoto>)photo {
  return nil;
}

- (NSString *)photosViewController:(NYTPhotosViewController *)photosViewController
                     titleForPhoto:(id<NYTPhoto>)photo
                           atIndex:(NSInteger)photoIndex
                   totalPhotoCount:(nullable NSNumber *)totalPhotoCount {
  return [NSString stringWithFormat:@"%lu/%lu", (unsigned long)photoIndex + 1,
                                    (unsigned long)totalPhotoCount.integerValue];
}

- (void)photosViewController:(NYTPhotosViewController *)photosViewController
          didNavigateToPhoto:(id<NYTPhoto>)photo
                     atIndex:(NSUInteger)photoIndex {
  if (!photo.image && !photo.imageData) {
    [self updatePhotoAtIndex:photosViewController Index:photoIndex];
  }
  NSLog(@"Did Navigate To Photo: %@ identifier: %lu", photo, (unsigned long)photoIndex);
}

- (void)photosViewController:(NYTPhotosViewController *)photosViewController
    actionCompletedWithActivityType:(NSString *)activityType {
  NSLog(@"Action Completed With Activity Type: %@", activityType);
}

- (void)photosViewControllerDidDismiss:(NYTPhotosViewController *)photosViewController {
  NSLog(@"Did Dismiss Photo Viewer: %@", photosViewController);
}

@end
