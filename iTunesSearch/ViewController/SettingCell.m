//
//  SettingCell.m
//  iTunesSearch
//
//  Created by s_akiba on 12/12/10.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "SettingCell.h"


@implementation SettingCell

- (void) setUserImage {
    UserImageView *userImageView = [[UserImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [self addSubview:userImageView];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userImageUrl = [NSString stringWithFormat:@"%@%@%@", @"https://graph.facebook.com/", [defaults objectForKey:@"id"], @"/picture?type=square"];
    [userImageView setImageWithUrl:userImageUrl];
}

@end
