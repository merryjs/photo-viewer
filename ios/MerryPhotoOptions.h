//
//  MerryPhotoOptions.h
//  MerryPhotoViewer
//
//  Created by bang on 27/07/2017.
//  Copyright © 2017 Merryjs.com. All rights reserved.
//

#ifndef MerryPhotoOptions_h
#define MerryPhotoOptions_h
#import <UIKit/UIKit.h>
#import "MerryPhotoData.h"

@interface MerryPhotoOptions : NSObject

@property (nonatomic, strong) NSString * backgroundColor;
@property (nonatomic, strong) NSArray * data;
@property (nonatomic, assign) BOOL hideStatusBar;
@property (nonatomic, assign) NSInteger initial;
@property (nonatomic, strong) NSString * shareText;
@property (nonatomic, strong) NSString * shareTextColor;
@property (nonatomic, assign) BOOL swipeToDismiss;
@property (nonatomic, strong) NSString * titlePagerColor;
@property (nonatomic, assign) BOOL zooming;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;

@end
#endif /* MerryPhotoOptions_h */
