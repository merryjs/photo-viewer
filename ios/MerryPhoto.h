//
//  MerryPhoto.h
//  MerryPhotoViewer
//
//  Created by Qibang Sun on 15/07/2017.
//  Copyright © 2017 Merryjs.com All rights reserved.
//

#ifndef MerryPhoto_h
#define MerryPhoto_h
#import <Foundation/Foundation.h>
#import <NYTPhotoViewer/NYTPhoto.h>

@interface MerryPhoto : NSObject<NYTPhoto>

// Redeclare all the properties as readwrite for sample/testing purposes.
@property(nonatomic) UIImage *image;
@property(nonatomic) NSData *imageData;
@property(nonatomic) UIImage *placeholderImage;
@property(nonatomic) NSAttributedString *attributedCaptionTitle;
@property(nonatomic) NSAttributedString *attributedCaptionSummary;
@property(nonatomic) NSAttributedString *attributedCaptionCredit;

@end

#endif /* MerryPhoto_h */
