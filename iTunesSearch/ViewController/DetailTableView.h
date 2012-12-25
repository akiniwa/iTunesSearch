//
//  DetailTableView.h
//  iTunesSearch
//
//  Created by s_akiba on 12/12/10.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTableView : UITableView

@property (nonatomic, retain) NSString *urlString;
@property (nonatomic, retain) NSString *pocket_id;
@property BOOL is_editable;

- (void)mainTableLoad;

@end
