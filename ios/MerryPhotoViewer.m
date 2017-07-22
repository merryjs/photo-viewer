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
  //    NSLog(@"URL: %@", url);

  NSData *imageFromUrl = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
  return [UIImage imageWithData:imageFromUrl];
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
    //        NSString *url = photos[i];
    //    NSLog(@"URL: %@", url);

    //        NSData *imageFromUrl = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    // merryPhoto.image = [UIImage imageWithData:imageFromUrl];
    merryPhoto.image = nil;
    //        merryPhoto.imageData = imageFromUrl;
    merryPhoto.imageData = nil;

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
    if ((int)initialPhoto >= 0) {
      [self updatePhotoAtIndex:photosViewController:initialPhoto];
    }

  });
}

#pragma mark - NYTPhotosViewControllerDelegate
//
//- (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController
//           referenceViewForPhoto:(id<NYTPhoto>)photo {
//    if ([photo isEqual:self.photos[NYTViewControllerPhotoIndexNoReferenceView]]) {
//        return nil;
//    }
//
//    return nil;
//    //    return self.imageButton;
//}
//
//- (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController
//             loadingViewForPhoto:(id<NYTPhoto>)photo {
//    if ([photo isEqual:self.photos[NYTViewControllerPhotoIndexCustomEverything]]) {
//        UILabel *loadingLabel = [[UILabel alloc] init];
//        loadingLabel.text = @"Custom Loading...";
//        loadingLabel.textColor = [UIColor greenColor];
//        return loadingLabel;
//    }
//
//    return nil;
//}
//
//- (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController
//             captionViewForPhoto:(id<NYTPhoto>)photo {
//    if ([photo isEqual:self.photos[NYTViewControllerPhotoIndexCustomEverything]]) {
//        UILabel *label = [[UILabel alloc] init];
//        label.text = @"Custom Caption View";
//        label.textColor = [UIColor whiteColor];
//        label.backgroundColor = [UIColor redColor];
//        return label;
//    }
//
//    return nil;
//}
//
//- (CGFloat)photosViewController:(NYTPhotosViewController *)photosViewController
//       maximumZoomScaleForPhoto:(id<NYTPhoto>)photo {
//    if ([photo isEqual:self.photos[NYTViewControllerPhotoIndexCustomMaxZoomScale]]) {
//        return 10.0f;
//    }
//
//    return 1.0f;
//}
//
//- (NSDictionary *)photosViewController:(NYTPhotosViewController *)photosViewController
//    overlayTitleTextAttributesForPhoto:(id<NYTPhoto>)photo {
//    if ([photo isEqual:self.photos[NYTViewControllerPhotoIndexCustomEverything]]) {
//        return @{NSForegroundColorAttributeName : [UIColor grayColor]};
//    }
//
//    return nil;
//}
//
//- (NSString *)photosViewController:(NYTPhotosViewController *)photosViewController
//                     titleForPhoto:(id<NYTPhoto>)photo
//                           atIndex:(NSUInteger)photoIndex
//                   totalPhotoCount:(NSUInteger)totalPhotoCount {
//    if ([photo isEqual:self.photos[NYTViewControllerPhotoIndexCustomEverything]]) {
//        return [NSString
//                stringWithFormat:@"%lu/%lu", (unsigned long)photoIndex + 1, (unsigned
//                long)totalPhotoCount];
//    }
//
//    return nil;
//}
//

/**
 update photo after 1s

 @param photosViewController <#photosViewController description#>
 @param photoIndex <#photoIndex description#>
 */
- (void)updatePhotoAtIndex:(NYTPhotosViewController *)photosViewController:(NSUInteger)photoIndex {
  NSInteger current = (unsigned long)photoIndex;
  CGFloat updateImageDelay = 0.3;
  MerryPhoto *currentPhoto = [self.dataSource.photos objectAtIndex:current];

  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(updateImageDelay * NSEC_PER_SEC)),
                 dispatch_get_main_queue(), ^{

                   currentPhoto.image = [self downloadImageById:current];

                   [photosViewController updatePhoto:currentPhoto];
                 });
}
- (void)photosViewController:(NYTPhotosViewController *)photosViewController
          didNavigateToPhoto:(id<NYTPhoto>)photo
                     atIndex:(NSUInteger)photoIndex {
  if (!photo.image && !photo.imageData) {
    [self updatePhotoAtIndex:photosViewController:photoIndex];
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
