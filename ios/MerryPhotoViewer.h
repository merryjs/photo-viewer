
#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif

#import <NYTPhotoViewer/NYTPhotosViewController.h>

@interface MerryPhotoViewer : NSObject<RCTBridgeModule>

@end
