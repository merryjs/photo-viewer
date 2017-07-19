
#import "MerryPhotoViewer.h"
#import "MerryPhoto.h"

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

RCT_EXPORT_MODULE()

- (NSDictionary *)constantsToExport {
  return @{@"SHORT" : [NSNumber numberWithDouble:1]};
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
 Create an internal method

 @param photos Photos Array
 */
- (void)_show:(NSArray *)photos:(NSInteger *)initial {

  for (int i = 0; i < photos.count; i++) {
    MerryPhoto *merryPhoto = [MerryPhoto new];
    NSString *url = photos[i];
//    NSLog(@"URL: %@", url);

    NSData *imageFromUrl = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    // merryPhoto.image = [UIImage imageWithData:imageFromUrl];
    merryPhoto.image = nil;
    merryPhoto.imageData = imageFromUrl;

    [self.photos addObject:merryPhoto];
  }

  dispatch_async(dispatch_get_main_queue(), ^{

    UIViewController *ctrl =
        [self visibleViewController:[UIApplication sharedApplication].keyWindow.rootViewController];

    NYTPhotosViewController *photosViewController =
        [[NYTPhotosViewController alloc] initWithPhotos:self.photos
                                           initialPhoto:[self.photos objectAtIndex:initial]];

    [ctrl presentViewController:photosViewController animated:YES completion:nil];
//    [self updateImagesOnPhotosViewController:photosViewController afterDelayWithPhotos:self.photos];

  });
}
// This method simulates previously blank photos loading their images after some time.
- (void)updateImagesOnPhotosViewController:(NYTPhotosViewController *)photosViewController afterDelayWithPhotos:(NSArray *)photos {
    CGFloat updateImageDelay = 5.0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(updateImageDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (MerryPhoto *photo in photos) {
            if (!photo.image && !photo.imageData) {
                photo.image = [UIImage imageNamed:@"NYTimesBuilding"];
                [photosViewController updateImageForPhoto:photo];
            }
        }
    });
}
/**
 Export for js use

 @param NSArray Photos Array

 */
RCT_EXPORT_METHOD(show : (NSArray *)photos : (NSInteger *)initial { [self _show:photos:initial]; });

#pragma mark - NYTPhotosViewControllerDelegate

- (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController
           referenceViewForPhoto:(id<NYTPhoto>)photo {
  if ([photo isEqual:self.photos[NYTViewControllerPhotoIndexNoReferenceView]]) {
    return nil;
  }

  return nil;
  //    return self.imageButton;
}

- (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController
             loadingViewForPhoto:(id<NYTPhoto>)photo {
  if ([photo isEqual:self.photos[NYTViewControllerPhotoIndexCustomEverything]]) {
    UILabel *loadingLabel = [[UILabel alloc] init];
    loadingLabel.text = @"Custom Loading...";
    loadingLabel.textColor = [UIColor greenColor];
    return loadingLabel;
  }

  return nil;
}

- (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController
             captionViewForPhoto:(id<NYTPhoto>)photo {
  if ([photo isEqual:self.photos[NYTViewControllerPhotoIndexCustomEverything]]) {
    UILabel *label = [[UILabel alloc] init];
    label.text = @"Custom Caption View";
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor redColor];
    return label;
  }

  return nil;
}

- (CGFloat)photosViewController:(NYTPhotosViewController *)photosViewController
       maximumZoomScaleForPhoto:(id<NYTPhoto>)photo {
  if ([photo isEqual:self.photos[NYTViewControllerPhotoIndexCustomMaxZoomScale]]) {
    return 10.0f;
  }

  return 1.0f;
}

- (NSDictionary *)photosViewController:(NYTPhotosViewController *)photosViewController
    overlayTitleTextAttributesForPhoto:(id<NYTPhoto>)photo {
  if ([photo isEqual:self.photos[NYTViewControllerPhotoIndexCustomEverything]]) {
    return @{NSForegroundColorAttributeName : [UIColor grayColor]};
  }

  return nil;
}

- (NSString *)photosViewController:(NYTPhotosViewController *)photosViewController
                     titleForPhoto:(id<NYTPhoto>)photo
                           atIndex:(NSUInteger)photoIndex
                   totalPhotoCount:(NSUInteger)totalPhotoCount {
  if ([photo isEqual:self.photos[NYTViewControllerPhotoIndexCustomEverything]]) {
    return [NSString
        stringWithFormat:@"%lu/%lu", (unsigned long)photoIndex + 1, (unsigned long)totalPhotoCount];
  }

  return nil;
}

- (void)photosViewController:(NYTPhotosViewController *)photosViewController
          didNavigateToPhoto:(id<NYTPhoto>)photo
                     atIndex:(NSUInteger)photoIndex {
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
