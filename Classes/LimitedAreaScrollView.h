//
//  LimitedAreaScrollView.h
//  PhotoScroller
//
//  Created by James Setaro on 8/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageScrollView.h"

#define PADDING  10
#define NUMPAGES 3
@interface LimitedAreaScrollView : UIScrollView <UIScrollViewDelegate>
{
    NSMutableSet *recycledPages;
    NSMutableSet *visiblePages;
    CGRect _visibleRect;
    NSString *_bodyPart;
}

@property (nonatomic, assign) CGRect visibleRect;
@property (nonatomic, retain) NSString *bodyPart;

- (void)tilePages;
- (void)configure:(UIScrollView*)scrollView page:(ImageScrollView *)page forIndex:(NSUInteger)index;

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index;
- (void)tilePages;
- (ImageScrollView *)dequeueRecycledPage;
- (UIImage *)imageName:(NSString*)imageName;
- (CGRect)frameForPageAtIndex:(NSUInteger)index;

@end
