
#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif
#import <React/RCTView.h>
#import <NYTPhotoViewer/NYTPhotosViewController.h>
#import "MerryPhotoViewController.h"

@interface MerryPhotoViewer : NSObject<RCTBridgeModule>
@property (nonatomic) NSMutableArray *photos;
@property  MerryPhotoViewController* view;
@end
