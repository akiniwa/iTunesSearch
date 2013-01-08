//
//  SideFlipViewController.h
//  Neiro
//
//  Created by s_akiba on 13/01/08.
//  Copyright (c) 2013年 s_akiba. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PAGE_COUNT 4

@interface SideFlipScrollView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic, retain) id sideFlipDelegate;

- (void) setView;

@end
