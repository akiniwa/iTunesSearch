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
#define PLAY_BUTTON_WIDTH 40
#define PLAY_BUTTON_HEIGHT 40

@implementation DetailMusicView

@synthesize playButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(observe:) name:@"playingStatusChanged" object:nil];
        
        playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [playButton setImage:[UIImage imageNamed:@"jacket_play"] forState:UIControlStateNormal];
        [playButton setFrame:CGRectMake(PLAY_BUTTON_X, PLAY_BUTTON_Y, PLAY_BUTTON_WIDTH, PLAY_BUTTON_HEIGHT)];
        [self addSubview:playButton];
        
        
    }
    return self;
}

- (void)observe:(NSNotification*)notification {
    DEBUGLOG(@"object_class:%@:%d", notification.object, self.playButton.tag);
}

@end
