//
//  TLCell.h
//  iTunesSearch
//
//  Created by s_akiba on 12/12/06.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLCell : UITableViewCell

@property (nonatomic, retain) UIImageView *tlImageView;
@property (nonatomic, retain) UILabel *userName;
@property (nonatomic, retain) UILabel *pocketTitle;
@property (nonatomic, retain) UILabel *musicTitle;
@property (nonatomic, retain) UILabel *shared;
@property (nonatomic, retain) UIButton *shareButton;
@property (nonatomic, retain) UILabel *musicCount;

- (void)setButton;

@end