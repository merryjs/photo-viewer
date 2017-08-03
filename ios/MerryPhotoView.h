//  Created by react-native-create-bridge

// import UIKit so you can subclass off UIView
#import <UIKit/UIKit.h>

// import RCTBridge
#if __has_include(<React/RCTBridge.h>)
#import <React/RCTBridge.h>
#elif __has_include(“RCTBridge.h”)
#import “RCTBridge.h”
#else
#import “React / RCTBridge.h” // Required when used as a Pod in a Swift project
#endif
#import <React/RCTComponent.h>
#import <React/RCTInvalidating.h>

#import <NYTPhotoViewer/NYTPhotoViewerArrayDataSource.h>
#import <NYTPhotoViewer/NYTPhotosViewController.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "MerryPhoto.h"
#import "MerryPhotoOptions.h"

@class RCTEventDispatcher;

@interface MerryPhotoView : UIView <NYTPhotosViewControllerDelegate, RCTInvalidating>
// Define view properties here with @property
@property (nonatomic) NSInteger initial;
@property (nonatomic) NSDictionary* options;
@property (nonatomic) BOOL hideStatusBar;
@property (nonatomic, copy) RCTBubblingEventBlock onDismiss;
@property (nonatomic, copy) RCTBubblingEventBlock onNavigateToPhoto;

// Initializing with the event dispatcher allows us to communicate with JS
- (instancetype)initWithEventDispatcher:(RCTEventDispatcher*)eventDispatcher NS_DESIGNATED_INITIALIZER;

@property (nonatomic) NSMutableArray* photos;
@property (nonatomic) NYTPhotoViewerArrayDataSource* dataSource;
@end
