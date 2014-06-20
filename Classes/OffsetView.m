//
//  OffsetView.m
//  PhotoScroller
//
//  Created by James Setaro on 8/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "OffsetView.h"

@implementation OffsetView

@synthesize image = _image;
@synthesize offset;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    rect.origin.y = self.offset;
    [self.image drawInRect:rect];
}


@end
