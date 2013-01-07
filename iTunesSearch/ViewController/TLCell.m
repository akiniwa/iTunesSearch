//
//  TLCell.m
//  iTunesSearch
//
//  Created by s_akiba on 12/12/06.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "TLCell.h"
#import <QuartzCore/QuartzCore.h>

#define POCKET_TITLE_X 125
#define POCKET_TITLE_Y 15
#define POCKET_TITLE_WIDTH 170
#define POCKET_TITLE_HEGHIT 40

#define USER_NAME_X 140
#define USER_NAME_Y 75
#define USER_NAME_WIDTH 120
#define USER_NAME_HEIGHT 20

#define MUSIC_TITLE_X 145
#define MUSIC_TITLE_Y 70
#define MUSIC_TITLE_WIDTH 120
#define MUSIC_TITLE_HEIGHT 20

#define SHARED_X 140
#define SHARED_Y 60
#define SHARED_WIDTH 60
#define SHARED_HEGHIT 10

@implementation TLCell

@synthesize tlImageView, jacketBackGround, userName, musicTitle, shared, pocketTitle, shareButton, musicCount;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleGray;

        jacketBackGround = [[UIImageView alloc] initWithFrame:CGRectMake(7, 17, 102, 102)];
        [jacketBackGround setImage:[UIImage imageNamed:@"jacketImageBackGround"]];
        jacketBackGround.alpha = 0.0f;
        [self addSubview:jacketBackGround];
        
        tlImageView = [[UIImageView alloc] init];
        tlImageView.frame = CGRectMake(8, 18, 100, 100);
        tlImageView.layer.cornerRadius = 6;
        tlImageView.alpha = 0.0f;
        tlImageView.clipsToBounds = true;
        [self addSubview:tlImageView];
        
        pocketTitle = [[UILabel alloc] init];
        [pocketTitle setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
        [self setLabelProperty:pocketTitle];
        [self setLabelFrame:pocketTitle :CGRectMake(POCKET_TITLE_X, POCKET_TITLE_Y, POCKET_TITLE_WIDTH, POCKET_TITLE_HEGHIT)];
        [self addSubview:pocketTitle];
        
/*
        musicTitle = [[UILabel alloc] init];
        [musicTitle setFont:[UIFont systemFontOfSize:13]];
        [self setLabelProperty:musicTitle];
        [self setLabelFrame:musicTitle :CGRectMake(MUSIC_TITLE_X, MUSIC_TITLE_Y, MUSIC_TITLE_WIDTH, MUSIC_TITLE_HEIGHT)];
        [self addSubview:musicTitle];
*/        
        userName = [[UILabel alloc] init];
        [self setLabelProperty:userName];
        [userName setFont:[UIFont systemFontOfSize:10]];
        [self setLabelFrame:userName :CGRectMake(USER_NAME_X, USER_NAME_Y, USER_NAME_WIDTH, USER_NAME_HEIGHT)];
        [self addSubview:userName];

        musicCount = [[UILabel alloc] init];
        [musicCount setFont:[UIFont systemFontOfSize:11]];
        [self setLabelProperty:musicCount];
        [self setLabelFrame:musicCount :CGRectMake(SHARED_X , SHARED_Y, SHARED_WIDTH, SHARED_HEGHIT)];
        [self addSubview:musicCount];
        
        shared = [[UILabel alloc] init];
        [shared setFont:[UIFont systemFontOfSize:11]];
        [self setLabelProperty:shared];
        [self setLabelFrame:shared :CGRectMake(SHARED_X + 40, SHARED_Y, SHARED_WIDTH, SHARED_HEGHIT)];
        [self addSubview:shared];

        shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareButton setImage:[UIImage imageNamed:@"zip-icon"] forState:UIControlStateNormal];
        shareButton.frame = CGRectMake(130, 95, 42, 35);

        UIImageView *nextImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next"]];
        [nextImage setFrame:CGRectMake(293, 45, 20, 40)];
        [self addSubview:nextImage];
        
        DEBUGLOG(@"height:%f", self.bounds.size.height);

        UIImageView *lineImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line"]];
        [lineImage setFrame:CGRectMake(self.bounds.origin.x, 133, self.bounds.size.width, 2)];
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