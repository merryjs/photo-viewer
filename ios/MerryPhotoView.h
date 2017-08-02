//  Created by react-native-create-bridge

// import UIKit so you can subclass off UIView
#import <UIKit/UIKit.h>

#import <NYTPhotoViewer/NYTPhotoViewerArrayDataSource.h>
#import <NYTPhotoViewer/NYTPhotosViewController.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "MerryPhoto.h"
#import "MerryPhotoOptions.h"

@class RCTEventDispatcher;

@interface MerryPhotoView : UIView <NYTPhotosViewControllerDelegate>
// Define view properties here with @property

// Initializing with the event dispatcher allows us to communicate with JS
- (instancetype)initWithEventDispatcher:(RCTEventDispatcher*)eventDispatcher NS_DESIGNATED_INITIALIZER;

@property (nonatomic) NSMutableArray* photos;
@property (nonatomic) NSDictionary* options;
@property (nonatomic) NYTPhotoViewerArrayDataSource* dataSource;

@end
