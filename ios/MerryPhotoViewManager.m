//  Created by react-native-create-bridge

#import "MerryPhotoViewManager.h"
#import "MerryPhotoView.h"
#import <Foundation/Foundation.h>

// import RCTBridge
#if __has_include(<React/RCTBridge.h>)
#import <React/RCTBridge.h>
#elif __has_include(“RCTBridge.h”)
#import “RCTBridge.h”
#else
#import “React / RCTBridge.h” // Required when used as a Pod in a Swift project
#endif

@implementation MerryPhotoViewManager

@synthesize bridge = _bridge;

// Export a native module
// https://facebook.github.io/react-native/docs/native-modules-ios.html
RCT_EXPORT_MODULE();

// Return the native view that represents your React component
- (UIView*)view
{
    return [[MerryPhotoView alloc] initWithEventDispatcher:self.bridge.eventDispatcher];
}

RCT_EXPORT_VIEW_PROPERTY(data, NSArray)
RCT_EXPORT_VIEW_PROPERTY(initial, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(hideStatusBar, BOOL)
RCT_EXPORT_VIEW_PROPERTY(hideCloseButton, BOOL)
RCT_EXPORT_VIEW_PROPERTY(hideShareButton, BOOL)

RCT_EXPORT_VIEW_PROPERTY(onDismiss, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onNavigateToPhoto, RCTBubblingEventBlock)

@end
