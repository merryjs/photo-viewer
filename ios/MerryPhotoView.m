//  Created by react-native-create-bridge
#import "MerryPhotoView.h"
#import <Foundation/Foundation.h>

// import RCTEventDispatcher
#if __has_include(<React/RCTEventDispatcher.h>)
#import <React/RCTConvert.h>
#import <React/RCTEventDispatcher.h>
#elif __has_include(“RCTEventDispatcher.h”)
#import “RCTEventDispatcher.h”
#else
#import “React / RCTEventDispatcher.h” // Required when used as a Pod in a Swift project
#endif

@implementation MerryPhotoView : UIView {
    RCTEventDispatcher* _eventDispatcher;
    BOOL presented;
    MerryPhotoOptions* merryPhotoOptions;
    SDWebImageDownloader* downloader;
}

- (instancetype)initWithEventDispatcher:(RCTEventDispatcher*)eventDispatcher
{
    if ((self = [super init])) {
        _eventDispatcher = eventDispatcher;
    }

    return self;
}
- (void)didMoveToWindow
{
    if (self.options) {
        [self showViewer:self.options];
    }
}
- (void)removeFromSuperview
{
    [self hideViewer];
}
- (void)invalidate
{
    [self hideViewer];
}
/**
 Get root view

 @param rootViewController <#rootViewController description#>
 @return presented View
 */
- (UIViewController*)visibleViewController:(UIViewController*)rootViewController
{
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    if ([rootViewController.presentedViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController.presentedViewController;
        UIViewController* lastViewController = [[navigationController viewControllers] lastObject];

        return [self visibleViewController:lastViewController];
    }
    if ([rootViewController.presentedViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController.presentedViewController;
        UIViewController* selectedViewController = tabBarController.selectedViewController;

        return [self visibleViewController:selectedViewController];
    }

    UIViewController* presentedViewController = (UIViewController*)rootViewController.presentedViewController;

    return [self visibleViewController:presentedViewController];
}

- (UIViewController*)getRootView
{
    UIViewController* rootView =
        [self visibleViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
    return rootView;
}

- (void)hideViewer
{
    if (!presented) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{

        [[self getRootView] dismissViewControllerAnimated:YES
                                               completion:^{
                                                   presented = NO;
                                               }];

    });
}

- (void)showViewer:(NSDictionary*)options
{
    merryPhotoOptions = [[MerryPhotoOptions alloc] initWithDictionary:options];

    if (presented) {
        return;
    }
    if (!merryPhotoOptions) {
        //        reject(@"9527", @"Display photo viewer failed, please config it first", nil);
        return;
    }

    NSMutableArray* msPhotos = [NSMutableArray array];
    for (MerryPhotoData* d in merryPhotoOptions.data) {
        MerryPhoto* merryPhoto = [MerryPhoto new];

        merryPhoto.image = nil;

        if (d.title) {
            merryPhoto.attributedCaptionTitle = [MerryPhotoView attributedTitleFromString:d.title:d.titleColor ? [RCTConvert UIColor:d.titleColor] : [UIColor whiteColor]];
        }
        if (d.summary) {
            merryPhoto.attributedCaptionSummary = [MerryPhotoView attributedSummaryFromString:d.summary:d.summaryColor ? [RCTConvert UIColor:d.summaryColor] : [UIColor lightGrayColor]];
        }
        [msPhotos addObject:merryPhoto];
    }

    self.photos = msPhotos;
    self.dataSource = [NYTPhotoViewerArrayDataSource dataSourceWithPhotos:self.photos];
    NSInteger initialPhoto = self.initial;

    dispatch_async(dispatch_get_main_queue(), ^{

        @try {
            NYTPhotosViewController* photosViewController = [[NYTPhotosViewController alloc]
                initWithDataSource:self.dataSource
                      initialPhoto:[self.photos objectAtIndex:initialPhoto]
                          delegate:self];

            [[self getRootView] presentViewController:photosViewController
                                             animated:YES
                                           completion:^{
                                               presented = YES;
                                           }];
            if (initialPhoto >= 0) {
                [self updatePhotoAtIndex:photosViewController Index:initialPhoto];
            }
            if (self.hideStatusBar) {
                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
            }
            //            resolve(@"");
        } @catch (NSException* exception) {
            //            reject(@"9527", @"Display photo viewer failed, please check your configurations", nil);
        } @finally {
        }

    });
}

/**
 Update Photo
 @param photosViewController <#photosViewController description#>
 @param photoIndex <#photoIndex description#>
 */
- (void)updatePhotoAtIndex:(NYTPhotosViewController*)photosViewController
                     Index:(NSUInteger)photoIndex
{
    NSInteger current = (unsigned long)photoIndex;
    MerryPhoto* currentPhoto = [self.dataSource.photos objectAtIndex:current];
    MerryPhotoData* d = merryPhotoOptions.data[current];

    NSString* url = d.url;
    NSURL* imageURL = [NSURL URLWithString:url];
    // check an url is a gif image.
    // NOTE: this check require your url have an extension.
    BOOL isGif = [[imageURL pathExtension] isEqual:@"gif"];

    downloader = [SDWebImageDownloader sharedDownloader];

    //      Limit only one photo will be download
    [downloader setMaxConcurrentDownloads:1];
    // cancel all downloads
    [downloader cancelAllDownloads];

    dispatch_async(dispatch_get_main_queue(), ^{

        [downloader
            downloadImageWithURL:imageURL
            options:0
            progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL* _Nullable targetURL) {
                // dispatch_sync(dispatch_get_main_queue(), ^{
                //     float progress = (float)receivedSize / expectedSize;
                //     NSLog(@" %lu/%lu", receivedSize, expectedSize);
                // });
            }
            completed:^(UIImage* image, NSData* data, NSError* error, BOOL finished) {
                //                       when downloads completed update photo
                if (image && finished) {
                    if (isGif) {
                        currentPhoto.imageData = data;
                    } else {
                        currentPhoto.image = image;
                    }
                    [photosViewController updatePhoto:currentPhoto];
                }
            }];

    });
}

#pragma mark - NYTPhotosViewControllerDelegate
- (UIView*)photosViewController:(NYTPhotosViewController*)photosViewController loadingViewForPhoto:(id<NYTPhoto>)photo
{
    return nil;
}
- (UIView*)photosViewController:(NYTPhotosViewController*)photosViewController
          referenceViewForPhoto:(id<NYTPhoto>)photo
{
    return nil;
}

/**
 Customize title display

 @param photosViewController <#photosViewController description#>
 @param photo <#photo description#>
 @param photoIndex <#photoIndex description#>
 @param totalPhotoCount <#totalPhotoCount description#>
 @return <#return value description#>
 */
- (NSString*)photosViewController:(NYTPhotosViewController*)photosViewController
                    titleForPhoto:(id<NYTPhoto>)photo
                          atIndex:(NSInteger)photoIndex
                  totalPhotoCount:(nullable NSNumber*)totalPhotoCount
{
    return [NSString stringWithFormat:@"%lu / %lu", (unsigned long)photoIndex + 1,
                     (unsigned long)totalPhotoCount.integerValue];
}

/**
 Download current photo if its nil

 @param photosViewController <#photosViewController description#>
 @param photo <#photo description#>
 @param photoIndex <#photoIndex description#>
 */
- (void)photosViewController:(NYTPhotosViewController*)photosViewController
          didNavigateToPhoto:(id<NYTPhoto>)photo
                     atIndex:(NSUInteger)photoIndex
{
    if (!photo.image && !photo.imageData) {
        [self updatePhotoAtIndex:photosViewController Index:photoIndex];
    }
    NSNumber* index = [[NSNumber alloc] initWithLong:photoIndex];
    if (self.onNavigateToPhoto) {
        self.onNavigateToPhoto(@{
            @"currentPhoto" : @{
                @"index" : index,
                @"photo" : photo
            }

        });
    }
    //  NSLog(@"Did Navigate To Photo: %@ identifier: %lu", photo, (unsigned long)photoIndex);
}

- (void)photosViewController:(NYTPhotosViewController*)photosViewController
    actionCompletedWithActivityType:(NSString*)activityType
{
    NSLog(@"Action Completed With Activity Type: %@", activityType);
}

- (void)photosViewControllerDidDismiss:(NYTPhotosViewController*)photosViewController
{
    //  NSLog(@"Did Dismiss Photo Viewer: %@", photosViewController);
    presented = NO;
    merryPhotoOptions = nil;
    if (self.hideStatusBar) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    }
    if (downloader) {
        [downloader cancelAllDownloads];
    }
    if (self.onDismiss) {
        self.onDismiss(nil);
    }
}
- (BOOL)photosViewController:(NYTPhotosViewController*)photosViewController handleActionButtonTappedForPhoto:(id<NYTPhoto>)photo
{
    return NO;
}
- (BOOL)photosViewController:(NYTPhotosViewController*)photosViewController handleLongPressForPhoto:(id<NYTPhoto>)photo withGestureRecognizer:(UILongPressGestureRecognizer*)longPressGestureRecognizer
{
    return NO;
}

+ (NSAttributedString*)attributedTitleFromString:(NSString*)caption
                                                :(UIColor*)color
{
    return [[NSAttributedString alloc]
        initWithString:caption
            attributes:@{
                NSForegroundColorAttributeName : color,
                NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody]
            }];
}

+ (NSAttributedString*)attributedSummaryFromString:(NSString*)summary
                                                  :(UIColor*)color
{
    return [[NSAttributedString alloc]
        initWithString:summary
            attributes:@{
                NSForegroundColorAttributeName : color,
                NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody]
            }];
}

@end
