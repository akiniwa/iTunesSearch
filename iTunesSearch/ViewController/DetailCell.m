//
//  DetailCell.m
//  iTunesSearch
//
//  Created by s_akiba on 12/12/10.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "DetailCell.h"
#import "DetailMusicView.h"
#import <QuartzCore/QuartzCore.h>

#define ARTIST_NAME_X 70
#define ARTIST_NAME_Y 5
#define ARTIST_NAME_WIDTH 120
#define ARTIST_NAME_HEIGHT 20

#define MUSIC_TITLE_X 90
#define MUSIC_TITLE_Y 27
#define MUSIC_TITLE_WIDTH 120
#define MUSIC_TITLE_HEIGHT 20

@implementation DetailCell

@synthesize tlImageView, musicTitle, artist, musicView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleGray;

        artist = [[UILabel alloc] init];
        [artist setFont:[UIFont systemFontOfSize:9]];
        artist.backgroundColor = [UIColor clearColor];
        [self setLabelFrame:artist :CGRectMake(ARTIST_NAME_X, ARTIST_NAME_Y, ARTIST_NAME_WIDTH, ARTIST_NAME_HEIGHT)];
        [self addSubview:artist];
        
        musicTitle = [[UILabel alloc] init];
        [musicTitle setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
        musicTitle.backgroundColor = [UIColor clearColor];
        [self setLabelFrame:musicTitle :CGRectMake(MUSIC_TITLE_X, MUSIC_TITLE_Y, MUSIC_TITLE_WIDTH, MUSIC_TITLE_HEIGHT)];
        [self addSubview:musicTitle];

        tlImageView = [[UIImageView alloc] init];
        tlImageView.frame = CGRectMake(1, 1, 58, 58);
        tlImageView.layer.cornerRadius = 2;
        tlImageView.clipsToBounds = true;
        [self addSubview:tlImageView];

//       musicView = [[DetailMusicView alloc] initWithFrame:CGRectMake(100, 0, 50, 50)];
//       [self addSubview:musicView];
        
        UIImageView *lineImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line"]];
        [lineImage setFrame:CGRectMake(0, 58, 320, 2)];
        [self addSubview:lineImage];
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