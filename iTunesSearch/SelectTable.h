//
//  SelectTable.h
//  iTunesSearch
//
//  Created by s_akiba on 12/11/14.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectTable : UITableView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) id gridDelegate;

@end
