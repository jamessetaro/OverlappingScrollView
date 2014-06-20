//
//  OffsetView.h
//  PhotoScroller
//
//  Created by James Setaro on 8/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OffsetView : UIView
{
    UIImage *_image;
    int offset;
}
@property(nonatomic, retain) UIImage *image;
@property(nonatomic, assign) int offset;
@end
