//
//  UserView.m
//  iTunesSearch
//
//  Created by Shinya Akiba on 12/12/31.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "UserView.h"

@implementation UserView

@synthesize title, playlistInfo, userImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        title = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 310, 20)];
        [title setFont:[UIFont systemFontOfSize:10]];
        [title setBackgroundColor:[UIColor clearColor]];
        [self addSubview:title];

        playlistInfo = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, 310, 20)];
        [playlistInfo setFont:[UIFont systemFontOfSize:10]];
        [playlistInfo setBackgroundColor:[UIColor clearColor]];
        [self addSubview:playlistInfo];
        
        userImage = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 50, 50)];
        [userImage setBackgroundColor:[UIColor blackColor]];
        [self addSubview:userImage];
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.size.height - 2, self.bounds.size.width, 2)];
        [line setImage:[UIImage imageNamed:@"lineGray"]];
        [self addSubview:line];
    }
    return self;
}
@end