//  Created by react-native-create-bridge

#import "MerryPhotoViewManager.h"
#import "MerryPhotoView.h"
#import <Foundation/Foundation.h>

@implementation MerryPhotoViewManager

//@synthesize bridge = _bridge;

// Export a native module
// https://facebook.github.io/react-native/docs/native-modules-ios.html
RCT_EXPORT_MODULE();

// Return the native view that represents your React component
- (UIView*)view
{
    return [[MerryPhotoView alloc] initWithBridge:self.bridge];
}

RCT_EXPORT_VIEW_PROPERTY(data, NSArray)
RCT_EXPORT_VIEW_PROPERTY(initial, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(hideStatusBar, BOOL)
RCT_EXPORT_VIEW_PROPERTY(hideCloseButton, BOOL)
RCT_EXPORT_VIEW_PROPERTY(hideShareButton, BOOL)
RCT_EXPORT_VIEW_PROPERTY(hideTitle, BOOL)

RCT_EXPORT_VIEW_PROPERTY(onDismiss, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onChange, RCTBubblingEventBlock)

@end
