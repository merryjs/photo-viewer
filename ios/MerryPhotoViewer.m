
#import "MerryPhotoViewer.h"
#import "MerryPhoto.h"

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
- (void)_show:(NSArray *)photos {
  NSMutableArray *nytPhotos = [NSMutableArray array];

  for (int i = 0; i < photos.count; i++) {
    MerryPhoto *merryPhoto = [MerryPhoto new];
    NSString *url = photos[i];
    NSLog(@"URL: %@", url);

    NSData *imageFromUrl = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    // merryPhoto.image = [UIImage imageWithData:imageFromUrl];
    merryPhoto.image = nil;
    merryPhoto.imageData = imageFromUrl;

    [nytPhotos addObject:merryPhoto];
  }

  dispatch_async(dispatch_get_main_queue(), ^{

    UIViewController *ctrl =
        [self visibleViewController:[UIApplication sharedApplication].keyWindow.rootViewController];

    NYTPhotosViewController *photosViewController =
        [[NYTPhotosViewController alloc] initWithPhotos:nytPhotos initialPhoto:nil];
    [ctrl presentViewController:photosViewController animated:YES completion:nil];
  });
}

/**
 Export for js use

 @param NSArray Photos Array

 */
RCT_EXPORT_METHOD(show : (NSArray *)photos { [self _show:photos]; });

@end
