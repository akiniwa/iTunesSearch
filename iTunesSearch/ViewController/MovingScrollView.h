//
//  MovingScrollView.h
//  iTunesSearch
//
//  Created by s_akiba on 12/11/12.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovingScrollView : UIScrollView <UIScrollViewDelegate>
{
    NSInteger leftImageIndex;	// index of imageList
    
	NSInteger leftViewIndex;	// index of viewList
	NSInteger rightViewIndex;	// index of viewList
    
	BOOL autoScrollStopped;
}

@property (nonatomic, retain) NSArray* viewList;
@property (nonatomic, retain) NSArray* imageList;
//@property (nonatomic, retain) NSMutableArray* imageList;
@property (nonatomic, readonly, getter=isCirculated) BOOL circulated;
@property (nonatomic, retain) NSTimer* timer;

- (void) showView;

@end
