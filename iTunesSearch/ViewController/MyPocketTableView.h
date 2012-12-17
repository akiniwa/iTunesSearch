//
//  MyPocketTableView.h
//  iTunesSearch
//
//  Created by s_akiba on 12/12/06.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPocketTableView : UITableView
{
    BOOL is_button;
}

@property (nonatomic, retain) NSString *urlString;
@property (nonatomic, retain) id myPocketDelegate;

- (void) mainTableLoad;
- (void) setButton;

@end