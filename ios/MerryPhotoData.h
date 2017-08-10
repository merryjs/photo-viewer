//
//  MerryPhotoData.h
//  MerryPhotoViewer
//
//  Created by bang on 27/07/2017.
//  Copyright © 2017 Merryjs.com. All rights reserved.
//

#ifndef MerryPhotoData_h
#define MerryPhotoData_h
#import <UIKit/UIKit.h>

#import "MerryCommonHeader.h"

@interface MerryPhotoData : NSObject

@property (nonatomic, strong) NSString* summary;
@property (nonatomic, strong) NSString* summaryColor;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* titleColor;
@property (nonatomic) RCTImageSource* source;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end

#endif /* MerryPhotoData_h */
