//
//  GridViewController.h
//  iTunesSearch
//
//  Created by s_akiba on 12/11/14.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridView.h"

@interface GridViewController : UIViewController<UIScrollViewDelegate>
{
    GridView *gridView;
}
@property (nonatomic, retain) NSString *artistName;
@property (nonatomic, retain) id gridViewDelegate;

- (id)initWithFrame:(CGRect)frame;

@end
