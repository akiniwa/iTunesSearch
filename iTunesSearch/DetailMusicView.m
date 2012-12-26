//
//  DetailMusicView.m
//  iTunesSearch
//
//  Created by s_akiba on 12/12/26.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "DetailMusicView.h"

#define PLAY_BUTTON_X 0
#define PLAY_BUTTON_Y 0
#define PLAY_BUTTON_WIDTH 30
#define PLAY_BUTTON_HEIGHT 30

#define PAUSE_BUTTON_Y 30

@implementation DetailMusicView

@synthesize playButton, pauseButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [playButton setImage:[UIImage imageNamed:@"jacket_play"] forState:UIControlStateNormal];
        [playButton setFrame:CGRectMake(PLAY_BUTTON_X, PLAY_BUTTON_Y, PLAY_BUTTON_WIDTH, PLAY_BUTTON_HEIGHT)];
        [self addSubview:playButton];

        pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [pauseButton setImage:[UIImage imageNamed:@"pauseBtn"] forState:UIControlStateNormal];
        [pauseButton setFrame:CGRectMake(PLAY_BUTTON_X, PAUSE_BUTTON_Y, PLAY_BUTTON_WIDTH, PLAY_BUTTON_HEIGHT)];
        [self addSubview:pauseButton];
    }
    return self;
}

- (void)playSound:(NSString *)url {
    [super playSound:url];
}

- (void)pauseSound {
    [super pauseSound];
}

@end