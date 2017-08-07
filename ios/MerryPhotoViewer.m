//
//  MerryPhotoViewController.m
//  MerryPhotoViewer
//
//  Created by bang on 19/07/2017.
//  Copyright © 2017 Merryjs.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MerryPhoto.h"
#import "MerryPhotoOptions.h"
#import "MerryPhotoViewer.h"

@implementation MerryPhotoViewer {
    BOOL presented;
    MerryPhotoOptions* merryPhotoOptions;
    SDWebImageDownloader* downloader;
}

// tell React we want export this module
RCT_EXPORT_MODULE();

- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}
- (void)invalidate
{
    [self hide];
}
/**
   we want to auto generate some getters and setters for our bridge.
 */
//@synthesize bridge = _bridge;

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

RCT_EXPORT_METHOD(hide {
    if (!presented) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{

        [[self getRootView] dismissViewControllerAnimated:YES
                                               completion:^{
                                                   presented = NO;
                                               }];

    });

})

RCT_EXPORT_METHOD(show
                  : (NSDictionary*)options resolver
                  : (RCTPromiseResolveBlock)resolve rejecter
                  : (RCTPromiseRejectBlock)reject)
{
    merryPhotoOptions = [[MerryPhotoOptions alloc] initWithDictionary:options];

    if (presented) {
        return;
    }
    if (!merryPhotoOptions) {
        reject(@"9527", @"Display photo viewer failed, please config it first", nil);
        return;
    }

    NSMutableArray* msPhotos = [NSMutableArray array];
    for (MerryPhotoData* d in merryPhotoOptions.data) {
        MerryPhoto* merryPhoto = [MerryPhoto new];

        merryPhoto.image = nil;

        if (d.title) {
            merryPhoto.attributedCaptionTitle = [MerryPhotoViewer attributedTitleFromString:d.title:d.titleColor ? [RCTConvert UIColor:d.titleColor] : [UIColor whiteColor]];
        }
        if (d.summary) {
            merryPhoto.attributedCaptionSummary = [MerryPhotoViewer attributedSummaryFromString:d.summary:d.summaryColor ? [RCTConvert UIColor:d.summaryColor] : [UIColor lightGrayColor]];
        }
        [msPhotos addObject:merryPhoto];
    }

    self.photos = msPhotos;
    self.dataSource = [NYTPhotoViewerArrayDataSource dataSourceWithPhotos:self.photos];

    dispatch_async(dispatch_get_main_queue(), ^{

        @try {
            NYTPhotosViewController* photosViewController = [[NYTPhotosViewController alloc]
                initWithDataSource:self.dataSource
                      initialPhoto:[self.photos objectAtIndex:merryPhotoOptions.initial]
                          delegate:self];
            //   TODO add options for:
            // hide left bar button
            photosViewController.leftBarButtonItem = nil;
            // hide right bar button
            photosViewController.rightBarButtonItem = nil;

            [[self getRootView] presentViewController:photosViewController
                                             animated:YES
                                           completion:^{
                                               presented = YES;
                                           }];
            if (merryPhotoOptions.initial >= 0) {
                [self updatePhotoAtIndex:photosViewController Index:merryPhotoOptions.initial];
            }
            if (merryPhotoOptions.hideStatusBar) {
                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
            }
            resolve(@"");
        } @catch (NSException* exception) {
            reject(@"9527", @"Display photo viewer failed, please check your configurations", nil);
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

    //  NSLog(@"Did Navigate To Photo: %@ identifier: %lu", photo, (unsigned long)photoIndex);
}

- (void)photosViewController:(NYTPhotosViewController*)photosViewController
    actionCompletedWithActivityType:(NSString*)activityType
{
    NSLog(@"Action Completed With Activity Type: %@", activityType);
}

- (void)displayActivityViewController:(UIActivityViewController*)controller animated:(BOOL)animated
{

    [[self getRootView] presentViewController:controller animated:animated completion:nil];
}
- (BOOL)photosViewController:(NYTPhotosViewController*)photosViewController handleLongPressForPhoto:(id<NYTPhoto>)photo withGestureRecognizer:(UILongPressGestureRecognizer*)longPressGestureRecognizer
{

    if ((photosViewController.currentlyDisplayedPhoto.image || photosViewController.currentlyDisplayedPhoto.imageData)) {
        UIImage* image = photosViewController.currentlyDisplayedPhoto.image ? photosViewController.currentlyDisplayedPhoto.image : [UIImage imageWithData:photosViewController.currentlyDisplayedPhoto.imageData];
        UIActivityViewController* activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[ image ] applicationActivities:nil];

        activityViewController.completionWithItemsHandler = ^(NSString* __nullable activityType, BOOL completed, NSArray* __nullable returnedItems, NSError* __nullable activityError) {
            if (completed && [photosViewController.delegate respondsToSelector:@selector(photosViewController:actionCompletedWithActivityType:)]) {
                [photosViewController.delegate photosViewController:photosViewController actionCompletedWithActivityType:activityType];
            }
        };

        [self displayActivityViewController:activityViewController animated:YES];
    }
    NSLog(@"You press me. %@", photo);
    return YES;
}
- (void)photosViewControllerDidDismiss:(NYTPhotosViewController*)photosViewController
{
    //  NSLog(@"Did Dismiss Photo Viewer: %@", photosViewController);
    presented = NO;
    merryPhotoOptions = nil;
    if (merryPhotoOptions.hideStatusBar) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    }
    if (downloader) {
        [downloader cancelAllDownloads];
    }
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
// if this is need will implement it in the future
//+ (NSAttributedString *)attributedCreditFromString:(NSString *)credit {
//  return [[NSAttributedString alloc]
//      initWithString:credit
//          attributes:@{
//            NSForegroundColorAttributeName : [UIColor grayColor],
//            NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1]
//          }];
//}
@end
