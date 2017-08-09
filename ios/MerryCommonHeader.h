//
//  ReactCommon.h
//  MerryPhotoViewer
//
//  Created by bang on 09/08/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#ifndef ReactCommon_h
#define ReactCommon_h

// import RCTBridge
#if __has_include(<React/RCTBridge.h>)
#import <React/RCTBridge.h>
#elif __has_include(“RCTBridge.h”)
#import “RCTBridge.h”
#else
#import “React / RCTBridge.h” // Required when used as a Pod in a Swift project
#endif

// import RCTEventDispatcher
#if __has_include(<React/RCTEventDispatcher.h>)
#import <React/RCTConvert.h>
#import <React/RCTEventDispatcher.h>
#import <React/RCTImageLoader.h>
#import <React/RCTImageSource.h>
#elif __has_include(“RCTEventDispatcher.h”)
#import “RCTConvert.h”
#import “RCTEventDispatcher.h”
#import “RCTImageSource.h”
#import “RCTImageLoader.h”

#else
#import “React / RCTEventDispatcher.h” // Required when used as a Pod in a Swift project
#endif

#endif /* ReactCommon_h */
