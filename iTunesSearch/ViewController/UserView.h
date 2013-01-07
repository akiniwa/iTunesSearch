//
//  UserView.h
//  iTunesSearch
//
//  Created by Shinya Akiba on 12/12/31.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserImageView.h"

@interface UserView : UIView

@property (nonatomic, retain) UILabel *title;
@property (nonatomic, retain) UILabel *playlistInfo;
@property (nonatomic, retain) UserImageView *userImage;

@end
