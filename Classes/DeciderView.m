//
//  DeciderView.m
//  PhotoScroller
//
//  Created by James Setaro on 8/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DeciderView.h"
#import "LimitedAreaScrollView.h"
@implementation DeciderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {

    for (LimitedAreaScrollView *view in self.subviews) {
        if(CGRectContainsPoint(view.visibleRect, point))
            return view;
    }
    return nil;
}



@end
