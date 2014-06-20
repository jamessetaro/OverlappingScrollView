//
//  LimitedAreaScrollView.m
//  PhotoScroller
//
//  Created by James Setaro on 8/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LimitedAreaScrollView.h"

@implementation LimitedAreaScrollView
@synthesize visibleRect = _visibleRect;
@synthesize bodyPart = _bodyPart;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        recycledPages = [[NSMutableSet alloc] init];
        visiblePages  = [[NSMutableSet alloc] init];
    }
    return self;
}




- (void)dealloc
{
    [recycledPages release];
    recycledPages = nil;
    [visiblePages release];
    visiblePages = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Tiling and page configuration

- (void)tilePages
{
    // Calculate which pages are visible
    CGRect visibleBounds = self.bounds;
    int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    int lastNeededPageIndex  = floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
    lastNeededPageIndex  = MIN(lastNeededPageIndex, NUMPAGES - 1);
    
    // Recycle no-longer-visible pages 
    for (ImageScrollView *page in visiblePages) {
        if (page.index < firstNeededPageIndex || page.index > lastNeededPageIndex) {
            [recycledPages addObject:page];
            [page removeFromSuperview];
        }
    }
    [visiblePages minusSet:recycledPages];

    // add missing pages
    for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) {
        if (![self isDisplayingPageForIndex:index]) {
            ImageScrollView *page = [self dequeueRecycledPage];
            if (page == nil) {
                page = [[[ImageScrollView alloc] init] autorelease];
            }
            [self configure:self page:page forIndex:index];
            [self addSubview:page];
            [visiblePages addObject:page];
        }
    }    
}

- (ImageScrollView *)dequeueRecycledPage
{
    ImageScrollView *page = [recycledPages anyObject];
    if (page) {
        [[page retain] autorelease];
        [recycledPages removeObject:page];
    }
    return page;
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index
{
    for (ImageScrollView *page in visiblePages) {
        if (page.index == index) {
            return YES;
        }
    }
    return NO;
}

- (void)configure:(UIScrollView*)scrollView page:(ImageScrollView *)page forIndex:(NSUInteger)index
{
    page.index = index;
    page.frame = [self frameForPageAtIndex:index];
    
    [page displayImage:[self imageName:[NSString stringWithFormat:@"%@%i", self.bodyPart, index + 1]] inFrame:self.frame];
    
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index {
    // We have to use our paging scroll view's bounds, not frame, to calculate the page placement. When the device is in
    // landscape orientation, the frame will still be in portrait because the pagingScrollView is the root view controller's
    // view, so its frame is in window coordinate space, which is never rotated. Its bounds, however, will be in landscape
    // because it has a rotation transform applied.
    CGRect bounds = self.bounds;
    CGRect pageFrame = bounds;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (bounds.size.width * index) + PADDING;
    return pageFrame;
}

- (UIImage *)imageName:(NSString*)imageName {
    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
    NSLog(@"path = %@", path);
    return [UIImage imageWithContentsOfFile:path];    
}


#pragma mark -
#pragma mark ScrollView delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self tilePages];
    
}


@end
