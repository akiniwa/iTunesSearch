//
//  DetailViewController.h
//  iTunesSearch
//
//  Created by s_akiba on 12/12/06.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailTableView.h"

@interface DetailViewController : UIViewController
{
    DetailTableView *detailTableView;
}

@property (nonatomic, retain) NSString *pocket_id;

@end
