//
//  MerryPhotoData.m
//  MerryPhotoViewer
//
//  Created by bang on 27/07/2017.
//  Copyright © 2017 Merryjs.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MerryPhotoData.h"

NSString* const kMerryPhotoDataSummary = @"summary";
NSString* const kMerryPhotoDataSummaryColor = @"summaryColor";
NSString* const kMerryPhotoDataTitle = @"title";
NSString* const kMerryPhotoDataTitleColor = @"titleColor";
NSString* const kMerryPhotoSource = @"source";

@interface MerryPhotoData ()
@end
@implementation MerryPhotoData

/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

- (instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (![dictionary[kMerryPhotoDataSummary] isKindOfClass:[NSNull class]]) {
        self.summary = dictionary[kMerryPhotoDataSummary];
    }
    if (![dictionary[kMerryPhotoDataSummaryColor] isKindOfClass:[NSNull class]]) {
        self.summaryColor = dictionary[kMerryPhotoDataSummaryColor];
    }
    if (![dictionary[kMerryPhotoDataTitle] isKindOfClass:[NSNull class]]) {
        self.title = dictionary[kMerryPhotoDataTitle];
    }
    if (![dictionary[kMerryPhotoDataTitleColor] isKindOfClass:[NSNull class]]) {
        self.titleColor = dictionary[kMerryPhotoDataTitleColor];
    }
    
    if (![dictionary[kMerryPhotoSource] isKindOfClass:[NSNull class]]) {
        self.source = [RCTConvert RCTImageSource: dictionary[kMerryPhotoSource]];
    }
    return self;
}
@end
