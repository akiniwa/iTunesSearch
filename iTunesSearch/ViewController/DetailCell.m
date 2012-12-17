//
//  DetailCell.m
//  iTunesSearch
//
//  Created by s_akiba on 12/12/10.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "DetailCell.h"

#define ARTIST_NAME_X 150
#define ARTIST_NAME_Y 50
#define ARTIST_NAME_WIDTH 120
#define ARTIST_NAME_HEIGHT 20

#define MUSIC_TITLE_X 150
#define MUSIC_TITLE_Y 20
#define MUSIC_TITLE_WIDTH 120
#define MUSIC_TITLE_HEIGHT 20

@implementation DetailCell

@synthesize tlImageView, musicTitle, artist;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        musicTitle = [[UILabel alloc] init];
        [musicTitle setFont:[UIFont systemFontOfSize:10]];
        [self setLabelFrame:musicTitle :CGRectMake(MUSIC_TITLE_X, MUSIC_TITLE_Y, MUSIC_TITLE_WIDTH, MUSIC_TITLE_HEIGHT)];
        [self addSubview:musicTitle];

        tlImageView = [[UIImageView alloc] init];
        tlImageView.frame = CGRectMake(10, 10, 80, 80);
        [self addSubview:tlImageView];

        artist = [[UILabel alloc] init];
        [artist setFont:[UIFont systemFontOfSize:10]];
        [self setLabelFrame:artist :CGRectMake(ARTIST_NAME_X, ARTIST_NAME_Y, ARTIST_NAME_WIDTH, ARTIST_NAME_HEIGHT)];
        [self addSubview:artist];
    }
    return self;
}

- (void) setLabelFrame:(UILabel*)labelInCell:(CGRect)rect {
    [labelInCell setFrame:rect];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end