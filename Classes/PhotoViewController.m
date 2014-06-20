

#import "PhotoViewController.h"
#import "ImageScrollView.h"
#import "LimitedAreaScrollView.h"
#import "DeciderView.h"

@interface PhotoViewController () 
@end

@implementation PhotoViewController

#pragma mark -
#pragma mark View loading and unloading

- (void)loadView 
{    
   
    // Step 1: make the outer paging scroll view
    CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
    pagingScrollView = [[LimitedAreaScrollView alloc] initWithFrame:pagingScrollViewFrame];
    pagingScrollView.pagingEnabled = YES;
    pagingScrollView.showsVerticalScrollIndicator = NO;
    pagingScrollView.showsHorizontalScrollIndicator = NO;
    pagingScrollView.contentSize = [self contentSizeForPagingScrollView:pagingScrollView];
    pagingScrollView.delegate = pagingScrollView;
    pagingScrollView.opaque = NO;
    pagingScrollView.bodyPart = @"head";
    
    // Step 2: make the body
    CGRect middleFrame = [self frameForPagingScrollView];
    middlePagingScrollView = [[LimitedAreaScrollView alloc] initWithFrame:middleFrame];
    middlePagingScrollView.pagingEnabled = YES;
    
    middlePagingScrollView.showsVerticalScrollIndicator = NO;
    middlePagingScrollView.showsHorizontalScrollIndicator = NO;
    middlePagingScrollView.contentSize = [self contentSizeForPagingScrollView:middlePagingScrollView];
    middlePagingScrollView.delegate = middlePagingScrollView;
    middlePagingScrollView.opaque = NO;
    middlePagingScrollView.bodyPart = @"body";
    
    // Step 2: make the legs
    CGRect bottomFrame = [self frameForPagingScrollView];
    bottomPagingScrollView = [[LimitedAreaScrollView alloc] initWithFrame:bottomFrame];
    bottomPagingScrollView.pagingEnabled = YES;
    bottomPagingScrollView.showsVerticalScrollIndicator = NO;
    bottomPagingScrollView.showsHorizontalScrollIndicator = NO;
    bottomPagingScrollView.contentSize = [self contentSizeForPagingScrollView:bottomPagingScrollView];
    bottomPagingScrollView.delegate = bottomPagingScrollView;
    bottomPagingScrollView.opaque = NO;
    bottomPagingScrollView.bodyPart = @"legs";
    
    
    CGRect frame = [[UIScreen mainScreen] bounds];

    DeciderView *decider = [[DeciderView alloc] initWithFrame:frame];
    decider.backgroundColor = [UIColor whiteColor];
    
    pagingScrollViewFrame.size.height /= NUMPAGES;
    pagingScrollView.visibleRect = pagingScrollViewFrame;
    
    middleFrame.size.height = pagingScrollViewFrame.size.height;
    middleFrame.origin.y = pagingScrollViewFrame.size.height;
    middlePagingScrollView.visibleRect = middleFrame;
    
    
    bottomFrame.size.height = pagingScrollViewFrame.size.height;
    bottomFrame.origin.y = middleFrame.origin.y + middleFrame.size.height;
    bottomPagingScrollView.visibleRect = bottomFrame;
    
    
    
    [decider addSubview:pagingScrollView];
    [decider addSubview:middlePagingScrollView];
    [decider addSubview:bottomPagingScrollView];
    
    
    self.view = decider;
    
    [pagingScrollView tilePages];
    [middlePagingScrollView tilePages];
    [bottomPagingScrollView tilePages];
    
}


- (void)dealloc
{
    [pagingScrollView release];
    [middlePagingScrollView release];
    [bottomPagingScrollView release];
    
    [super dealloc];
}




#pragma mark -
#pragma mark View controller rotation methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
{
    return NO;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // here, our pagingScrollView bounds have not yet been updated for the new interface orientation. So this is a good
    // place to calculate the content offset that we will need in the new orientation
    CGFloat offset = pagingScrollView.contentOffset.x;
    CGFloat pageWidth = pagingScrollView.bounds.size.width;
    
    if (offset >= 0) {
        firstVisiblePageIndexBeforeRotation = floorf(offset / pageWidth);
        percentScrolledIntoFirstVisiblePage = (offset - (firstVisiblePageIndexBeforeRotation * pageWidth)) / pageWidth;
    } else {
        firstVisiblePageIndexBeforeRotation = 0;
        percentScrolledIntoFirstVisiblePage = offset / pageWidth;
    }    
}
/*
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // recalculate contentSize based on current orientation
    pagingScrollView.contentSize = [self contentSizeForPagingScrollView:pagingScrollView];
    
    // adjust frames and configuration of each visible page
    for (ImageScrollView *page in visiblePages) {
        CGPoint restorePoint = [page pointToCenterAfterRotation];
        CGFloat restoreScale = [page scaleToRestoreAfterRotation];
        page.frame = [self frameForPageAtIndex:page.index];
        [page setMaxMinZoomScalesForCurrentBounds];
        [page restoreCenterPoint:restorePoint scale:restoreScale];
        
    }
    
    // adjust contentOffset to preserve page location based on values collected prior to location
    CGFloat pageWidth = pagingScrollView.bounds.size.width;
    CGFloat newOffset = (firstVisiblePageIndexBeforeRotation * pageWidth) + (percentScrolledIntoFirstVisiblePage * pageWidth);
    pagingScrollView.contentOffset = CGPointMake(newOffset, 0);
}
*/
#pragma mark -
#pragma mark  Frame calculations


- (CGRect)frameForPagingScrollView {
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.origin.x -= PADDING;
    frame.size.width += (2 * PADDING);
    return frame;
}



- (CGSize)contentSizeForPagingScrollView:(UIScrollView*)inView {
    // We have to use the paging scroll view's bounds to calculate the contentSize, for the same reason outlined above.
    CGRect bounds = inView.bounds;
    //return CGSizeMake(bounds.size.width * [self imageCount], bounds.size.height);
    return CGSizeMake(bounds.size.width * 3, 480);
    
}


#pragma mark -
#pragma mark Image wrangling

- (NSArray *)imageData {
    static NSArray *__imageData = nil; // only load the imageData array once
    if (__imageData == nil) {
        // read the filenames/sizes out of a plist in the app bundle
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ImageData" ofType:@"plist"];
        NSData *plistData = [NSData dataWithContentsOfFile:path];
        NSString *error; NSPropertyListFormat format;
        __imageData = [[NSPropertyListSerialization propertyListFromData:plistData
                                                        mutabilityOption:NSPropertyListImmutable
                                                                  format:&format
                                                        errorDescription:&error]
                       retain];
        if (!__imageData) {
            NSLog(@"Failed to read image names. Error: %@", error);
            [error release];
        }
    }
    return __imageData;
}




- (UIImage *)imageAtIndex:(NSUInteger)index {
    // use "imageWithContentsOfFile:" instead of "imageNamed:" here to avoid caching our images
    NSString *imageName = [self imageNameAtIndex:index];
    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"];
    return [UIImage imageWithContentsOfFile:path];    
}

- (NSString *)imageNameAtIndex:(NSUInteger)index {
    NSString *name = nil;
    if (index < [self imageCount]) {
        NSDictionary *data = [[self imageData] objectAtIndex:index];
        name = [data valueForKey:@"name"];
    }
    return name;
}

- (CGSize)imageSizeAtIndex:(NSUInteger)index {
    CGSize size = CGSizeZero;
    if (index < [self imageCount]) {
        NSDictionary *data = [[self imageData] objectAtIndex:index];
        size.width = [[data valueForKey:@"width"] floatValue];
        size.height = [[data valueForKey:@"height"] floatValue];
    }
    return size;
}

- (NSUInteger)imageCount {
    static NSUInteger __count = NSNotFound;  // only count the images once
    if (__count == NSNotFound) {
        __count = [[self imageData] count];
    }
    return __count;
}


@end
