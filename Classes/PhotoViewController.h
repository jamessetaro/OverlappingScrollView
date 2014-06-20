

#import <UIKit/UIKit.h>

@class ImageScrollView;
@class LimitedAreaScrollView;
@interface PhotoViewController : UIViewController  {
    LimitedAreaScrollView *pagingScrollView;
    LimitedAreaScrollView *middlePagingScrollView;
    LimitedAreaScrollView *bottomPagingScrollView;
    
   
    // these values are stored off before we start rotation so we adjust our content offset appropriately during rotation
    int           firstVisiblePageIndexBeforeRotation;
    CGFloat       percentScrolledIntoFirstVisiblePage;
}


- (NSUInteger)imageCount;
- (NSString *)imageNameAtIndex:(NSUInteger)index;
- (CGSize)imageSizeAtIndex:(NSUInteger)index;
- (UIImage *)imageAtIndex:(NSUInteger)index;

- (CGRect)frameForPagingScrollView;
//- (CGRect)frameForPageAtIndex:(NSUInteger)index;
- (CGSize)contentSizeForPagingScrollView:(UIScrollView*)inView;


@end

