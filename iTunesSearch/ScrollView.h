//
//  ScrollView.h
//  iTunesSearch
//
//  Created by s_akiba on 12/11/14.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//
// scrollviewにurlやアーティストの名前を渡し、viewに表示。
// urlから非同期に画像描写。

#import <UIKit/UIKit.h>

@interface ScrollView : UIScrollView<UIScrollViewDelegate>
{
    BOOL autoScrollStopped;
  	BOOL circulated;

    NSInteger leftImageIndex;
    
	NSInteger leftViewIndex;
	NSInteger rightViewIndex;
}

@property (nonatomic, retain) NSMutableArray* imageList;
@property (nonatomic, retain) NSMutableDictionary *items;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) id scrollViewDelegate;
@property (readwrite) NSInteger flag;

- (void)setItems;

@end
