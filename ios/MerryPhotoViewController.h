//
//  MerryPhotoViewController.h
//  MerryPhotoViewer
//
//  Created by bang on 19/07/2017.
//  Copyright © 2017 MerryJS. All rights reserved.
//

#ifndef MerryPhotoViewController_h
#define MerryPhotoViewController_h

#import <UIKit/UIKit.h>
#import <NYTPhotoViewer/NYTPhotosViewController.h>

@interface MerryPhotoViewController : UIViewController
@property (nonatomic) NSMutableArray *photos;
- (void) _show;
@end

#endif /* MerryPhotoViewController_h */
