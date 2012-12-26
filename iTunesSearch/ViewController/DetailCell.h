//
//  DetailCell.h
//  iTunesSearch
//
//  Created by s_akiba on 12/12/10.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DetailMusicView;

@interface DetailCell : UITableViewCell

@property (nonatomic, retain) UIImageView *tlImageView;
@property (nonatomic, retain) UILabel *musicTitle;
@property (nonatomic, retain) UILabel *artist;
@property (nonatomic, retain) DetailMusicView *musicView;

@end