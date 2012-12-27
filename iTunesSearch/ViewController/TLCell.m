//
//  TLCell.m
//  iTunesSearch
//
//  Created by s_akiba on 12/12/06.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "TLCell.h"
#import <QuartzCore/QuartzCore.h>


#define USER_NAME_X 150
#define USER_NAME_Y 60
#define USER_NAME_WIDTH 120
#define USER_NAME_HEIGHT 20

#define MUSIC_TITLE_X 150
#define MUSIC_TITLE_Y 80
#define MUSIC_TITLE_WIDTH 120
#define MUSIC_TITLE_HEIGHT 20

#define SHARED_X 250
#define SHARED_Y 100
#define SHARED_WIDTH 20
#define SHARED_HEGHIT 10

#define POCKET_TITLE_X 150
#define POCKET_TITLE_Y 10
#define POCKET_TITLE_WIDTH 120
#define POCKET_TITLE_HEGHIT 20

@implementation TLCell

@synthesize tlImageView, userName, musicTitle, shared, pocketTitle, shareButton, musicCount;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleGray;

        userName = [[UILabel alloc] init];
        [self setLabelProperty:userName];
        [userName setFont:[UIFont systemFontOfSize:10]];
        [self setLabelFrame:userName :CGRectMake(USER_NAME_X, USER_NAME_Y, USER_NAME_WIDTH, USER_NAME_HEIGHT)];
        [self addSubview:userName];

        musicTitle = [[UILabel alloc] init];
        [musicTitle setFont:[UIFont systemFontOfSize:10]];
        [self setLabelProperty:musicTitle];
        [self setLabelFrame:musicTitle :CGRectMake(MUSIC_TITLE_X, MUSIC_TITLE_Y, MUSIC_TITLE_WIDTH, MUSIC_TITLE_HEIGHT)];
        [self addSubview:musicTitle];
        
        shared = [[UILabel alloc] init];
        [shared setFont:[UIFont systemFontOfSize:9]];
        [self setLabelProperty:shared];
        [self setLabelFrame:shared :CGRectMake(SHARED_X, SHARED_Y, SHARED_WIDTH, SHARED_HEGHIT)];
        [self addSubview:shared];
        
        pocketTitle = [[UILabel alloc] init];
        [pocketTitle setFont:[UIFont systemFontOfSize:13]];
        [self setLabelProperty:pocketTitle];
        [self setLabelFrame:pocketTitle :CGRectMake(POCKET_TITLE_X, POCKET_TITLE_Y, POCKET_TITLE_WIDTH, POCKET_TITLE_HEGHIT)];
        [self addSubview:pocketTitle];
        
        tlImageView = [[UIImageView alloc] init];
        tlImageView.frame = CGRectMake(10, 10, 100, 100);
        tlImageView.layer.cornerRadius = 8;
        tlImageView.clipsToBounds = true;
        [self addSubview:tlImageView];

        musicCount = [[UILabel alloc] init];
        [musicCount setFont:[UIFont systemFontOfSize:9]];
        [self setLabelProperty:musicCount];
        [self setLabelFrame:musicCount :CGRectMake(SHARED_X, SHARED_Y -20 , SHARED_WIDTH, SHARED_HEGHIT)];
        [self addSubview:musicCount];

        shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        shareButton.frame = CGRectMake(160, 100, 80, 40);
        [shareButton setTitle:@"share" forState:UIControlStateNormal];

        UIImageView *nextImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next"]];
        [nextImage setFrame:CGRectMake(290, self.bounds.size.height, 20, 40)];
        [self addSubview:nextImage];
        
        UIImageView *lineImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line"]];
        [lineImage setFrame:CGRectMake(0, 0, 320, 2)];
        [self addSubview:lineImage];
    }
    return self;
}

- (void) setLabelProperty:(UILabel*)label {
    [label setBackgroundColor:[UIColor clearColor]];
}

- (void) setButton {
    [self addSubview:shareButton];
}

- (void) removeButton {
    [shareButton removeFromSuperview];
}

- (void) setLabelFrame:(UILabel*)labelInCell:(CGRect)rect {
    [labelInCell setFrame:rect];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end