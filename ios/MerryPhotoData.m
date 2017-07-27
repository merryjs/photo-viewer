//
//  MerryPhotoData.m
//  MerryPhotoViewer
//
//  Created by bang on 27/07/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
    //
    //	Data.m
    //	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "MerryPhotoData.h"

NSString *const kDataSummary = @"summary";
NSString *const kDataSummaryColor = @"summaryColor";
NSString *const kDataTitle = @"title";
NSString *const kDataTitleColor = @"titleColor";
NSString *const kDataUrl = @"url";

@interface MerryPhotoData ()
@end
@implementation MerryPhotoData




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kDataSummary] isKindOfClass:[NSNull class]]){
        self.summary = dictionary[kDataSummary];
    }
    if(![dictionary[kDataSummaryColor] isKindOfClass:[NSNull class]]){
        self.summaryColor = dictionary[kDataSummaryColor];
    }
    if(![dictionary[kDataTitle] isKindOfClass:[NSNull class]]){
        self.title = dictionary[kDataTitle];
    }
    if(![dictionary[kDataTitleColor] isKindOfClass:[NSNull class]]){
        self.titleColor = dictionary[kDataTitleColor];
    }
    if(![dictionary[kDataUrl] isKindOfClass:[NSNull class]]){
        self.url = dictionary[kDataUrl];
    }
    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    if(self.summary != nil){
        dictionary[kDataSummary] = self.summary;
    }
    if(self.summaryColor != nil){
        dictionary[kDataSummaryColor] = self.summaryColor;
    }
    if(self.title != nil){
        dictionary[kDataTitle] = self.title;
    }
    if(self.titleColor != nil){
        dictionary[kDataTitleColor] = self.titleColor;
    }
    if(self.url != nil){
        dictionary[kDataUrl] = self.url;
    }
    return dictionary;
    
}

/**
 * Implementation of NSCoding encoding method
 */
/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    if(self.summary != nil){
        [aCoder encodeObject:self.summary forKey:kDataSummary];
    }
    if(self.summaryColor != nil){
        [aCoder encodeObject:self.summaryColor forKey:kDataSummaryColor];
    }
    if(self.title != nil){
        [aCoder encodeObject:self.title forKey:kDataTitle];
    }
    if(self.titleColor != nil){
        [aCoder encodeObject:self.titleColor forKey:kDataTitleColor];
    }
    if(self.url != nil){
        [aCoder encodeObject:self.url forKey:kDataUrl];
    }
    
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.summary = [aDecoder decodeObjectForKey:kDataSummary];
    self.summaryColor = [aDecoder decodeObjectForKey:kDataSummaryColor];
    self.title = [aDecoder decodeObjectForKey:kDataTitle];
    self.titleColor = [aDecoder decodeObjectForKey:kDataTitleColor];
    self.url = [aDecoder decodeObjectForKey:kDataUrl];
    return self;
    
}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
    MerryPhotoData *copy = [MerryPhotoData new];
    
    copy.summary = [self.summary copy];
    copy.summaryColor = [self.summaryColor copy];
    copy.title = [self.title copy];
    copy.titleColor = [self.titleColor copy];
    copy.url = [self.url copy];
    
    return copy;
}
@end
