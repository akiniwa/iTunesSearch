//
//  GridViewController.h
//  iTunesSearch
//
//  Created by s_akiba on 12/11/14.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridView.h"
#import "PostMutableArray.h"

@interface GridViewController : UIViewController<UIScrollViewDelegate>
{
    GridView *gridView;
    UIScrollView *scrollView;
    
    PostMutableArray *postMutableArray;
    NSMutableDictionary *selectDictionary;
    NSMutableDictionary *items;
}

@property (nonatomic, retain) NSString *artistName;
@property (nonatomic, retain) id gridViewDelegate;

- (void) notificateNumbers:(NSMutableDictionary*)dictionary;
- (void) makeMutableArray;

@end