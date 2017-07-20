
#import "MerryPhotoViewer.h"
#import "MerryPhoto.h"

@implementation MerryPhotoViewer{
    MerryPhotoViewController *view;
}

RCT_EXPORT_MODULE()

- (MerryPhotoViewer *) init{
    view = [MerryPhotoViewController new];
    return self;
}

/**
 Export for js use

 @param NSArray Photos Array

 */
RCT_EXPORT_METHOD(show : (NSArray *)photos : (NSInteger *)initial {
    
});

@end
