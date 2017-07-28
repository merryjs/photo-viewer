//
//  MerryPhotoOptions.m
//  MerryPhotoViewer
//
//  Created by bang on 27/07/2017.
//  Copyright © 2017 Merryjs.com. All rights reserved.
//
//
//	MerryPhotoOptions.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "MerryPhotoOptions.h"

NSString *const kMerryPhotoOptionsBackgroundColor = @"backgroundColor";
NSString *const kMerryPhotoOptionsData = @"data";
NSString *const kMerryPhotoOptionsHideStatusBar = @"hideStatusBar";
NSString *const kMerryPhotoOptionsInitial = @"initial";
NSString *const kMerryPhotoOptionsShareText = @"shareText";
NSString *const kMerryPhotoOptionsShareTextColor = @"shareTextColor";
NSString *const kMerryPhotoOptionsSwipeToDismiss = @"swipeToDismiss";
NSString *const kMerryPhotoOptionsTitlePagerColor = @"titlePagerColor";
NSString *const kMerryPhotoOptionsZooming = @"zooming";

@interface MerryPhotoOptions ()
@end
@implementation MerryPhotoOptions




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kMerryPhotoOptionsBackgroundColor] isKindOfClass:[NSNull class]]){
        self.backgroundColor = dictionary[kMerryPhotoOptionsBackgroundColor];
    }
    if(dictionary[kMerryPhotoOptionsData] != nil && [dictionary[kMerryPhotoOptionsData] isKindOfClass:[NSArray class]]){
        NSArray * dataDictionaries = dictionary[kMerryPhotoOptionsData];
        NSMutableArray * dataItems = [NSMutableArray array];
        for(NSDictionary * dataDictionary in dataDictionaries){
            MerryPhotoData * dataItem = [[MerryPhotoData alloc] initWithDictionary:dataDictionary];
            [dataItems addObject:dataItem];
        }
        self.data = dataItems;
    }
    if(![dictionary[kMerryPhotoOptionsHideStatusBar] isKindOfClass:[NSNull class]]){
        self.hideStatusBar = [dictionary[kMerryPhotoOptionsHideStatusBar] boolValue];
    }

    if(![dictionary[kMerryPhotoOptionsInitial] isKindOfClass:[NSNull class]]){
        self.initial = [dictionary[kMerryPhotoOptionsInitial] integerValue];
    }

    if(![dictionary[kMerryPhotoOptionsShareText] isKindOfClass:[NSNull class]]){
        self.shareText = dictionary[kMerryPhotoOptionsShareText];
    }
    if(![dictionary[kMerryPhotoOptionsShareTextColor] isKindOfClass:[NSNull class]]){
        self.shareTextColor = dictionary[kMerryPhotoOptionsShareTextColor];
    }
    if(![dictionary[kMerryPhotoOptionsSwipeToDismiss] isKindOfClass:[NSNull class]]){
        self.swipeToDismiss = [dictionary[kMerryPhotoOptionsSwipeToDismiss] boolValue];
    }

    if(![dictionary[kMerryPhotoOptionsTitlePagerColor] isKindOfClass:[NSNull class]]){
        self.titlePagerColor = dictionary[kMerryPhotoOptionsTitlePagerColor];
    }
    if(![dictionary[kMerryPhotoOptionsZooming] isKindOfClass:[NSNull class]]){
        self.zooming = [dictionary[kMerryPhotoOptionsZooming] boolValue];
    }

    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    if(self.backgroundColor != nil){
        dictionary[kMerryPhotoOptionsBackgroundColor] = self.backgroundColor;
    }
    if(self.data != nil){
        NSMutableArray * dictionaryElements = [NSMutableArray array];
        for(MerryPhotoData * dataElement in self.data){
            [dictionaryElements addObject:[dataElement toDictionary]];
        }
        dictionary[kMerryPhotoOptionsData] = dictionaryElements;
    }
    dictionary[kMerryPhotoOptionsHideStatusBar] = @(self.hideStatusBar);
    dictionary[kMerryPhotoOptionsInitial] = @(self.initial);
    if(self.shareText != nil){
        dictionary[kMerryPhotoOptionsShareText] = self.shareText;
    }
    if(self.shareTextColor != nil){
        dictionary[kMerryPhotoOptionsShareTextColor] = self.shareTextColor;
    }
    dictionary[kMerryPhotoOptionsSwipeToDismiss] = @(self.swipeToDismiss);
    if(self.titlePagerColor != nil){
        dictionary[kMerryPhotoOptionsTitlePagerColor] = self.titlePagerColor;
    }
    dictionary[kMerryPhotoOptionsZooming] = @(self.zooming);
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
    if(self.backgroundColor != nil){
        [aCoder encodeObject:self.backgroundColor forKey:kMerryPhotoOptionsBackgroundColor];
    }
    if(self.data != nil){
        [aCoder encodeObject:self.data forKey:kMerryPhotoOptionsData];
    }
    [aCoder encodeObject:@(self.hideStatusBar) forKey:kMerryPhotoOptionsHideStatusBar];	[aCoder encodeObject:@(self.initial) forKey:kMerryPhotoOptionsInitial];	if(self.shareText != nil){
        [aCoder encodeObject:self.shareText forKey:kMerryPhotoOptionsShareText];
    }
    if(self.shareTextColor != nil){
        [aCoder encodeObject:self.shareTextColor forKey:kMerryPhotoOptionsShareTextColor];
    }
    [aCoder encodeObject:@(self.swipeToDismiss) forKey:kMerryPhotoOptionsSwipeToDismiss];	if(self.titlePagerColor != nil){
        [aCoder encodeObject:self.titlePagerColor forKey:kMerryPhotoOptionsTitlePagerColor];
    }
    [aCoder encodeObject:@(self.zooming) forKey:kMerryPhotoOptionsZooming];
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.backgroundColor = [aDecoder decodeObjectForKey:kMerryPhotoOptionsBackgroundColor];
    self.data = [aDecoder decodeObjectForKey:kMerryPhotoOptionsData];
    self.hideStatusBar = [[aDecoder decodeObjectForKey:kMerryPhotoOptionsHideStatusBar] boolValue];
    self.initial = [[aDecoder decodeObjectForKey:kMerryPhotoOptionsInitial] integerValue];
    self.shareText = [aDecoder decodeObjectForKey:kMerryPhotoOptionsShareText];
    self.shareTextColor = [aDecoder decodeObjectForKey:kMerryPhotoOptionsShareTextColor];
    self.swipeToDismiss = [[aDecoder decodeObjectForKey:kMerryPhotoOptionsSwipeToDismiss] boolValue];
    self.titlePagerColor = [aDecoder decodeObjectForKey:kMerryPhotoOptionsTitlePagerColor];
    self.zooming = [[aDecoder decodeObjectForKey:kMerryPhotoOptionsZooming] boolValue];
    return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
    MerryPhotoOptions *copy = [MerryPhotoOptions new];

    copy.backgroundColor = [self.backgroundColor copy];
    copy.data = [self.data copy];
    copy.hideStatusBar = self.hideStatusBar;
    copy.initial = self.initial;
    copy.shareText = [self.shareText copy];
    copy.shareTextColor = [self.shareTextColor copy];
    copy.swipeToDismiss = self.swipeToDismiss;
    copy.titlePagerColor = [self.titlePagerColor copy];
    copy.zooming = self.zooming;

    return copy;
}
@end
