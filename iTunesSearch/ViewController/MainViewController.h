//
//  MainViewController.h
//  iTunesSearch
//
//  Created by s_akiba on 12/10/25.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, retain) NSString *pocket_id;

- (void) setArray:(NSMutableDictionary*)dictionary;

@end