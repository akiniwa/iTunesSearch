//
//  MyPocketViewController.h
//  iTunesSearch
//
//  Created by s_akiba on 12/12/06.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPocketTableView.h"

@interface MyPocketViewController : UIViewController

@property (nonatomic, retain) NSString *urlString;
@property (nonatomic, retain) MyPocketTableView *myPocketTableView;

- (void)initialization;
- (void)setShareButton:(BOOL)is_button;

@end