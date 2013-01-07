//
//  DetailMusicView.m
//  iTunesSearch
//
//  Created by s_akiba on 12/12/26.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "DetailMusicView.h"
#import "DiscRotationView.h"

#define PLAY_BUTTON_X 0
#define PLAY_BUTTON_Y 0
#define PLAY_BUTTON_WIDTH 30
#define PLAY_BUTTON_HEIGHT 30

#define PAUSE_BUTTON_X 40


@implementation DetailMusicView
{
    DiscRotationView *discRotationView;
}

@synthesize pauseButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [pauseButton setImage:[UIImage imageNamed:@"pauseBtn"] forState:UIControlStateNormal];
        [pauseButton setFrame:CGRectMake(PAUSE_BUTTON_X, PLAY_BUTTON_Y, PLAY_BUTTON_WIDTH, PLAY_BUTTON_HEIGHT)];
        [pauseButton addTarget:self action:@selector(pauseSound) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:pauseButton];

        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(setTrackUrl:) name:@"trackUrl" object:nil];
        [nc addObserver:self selector:@selector(playing) name:@"playing" object:nil];
        [nc addObserver:self selector:@selector(pause) name:@"pause" object:nil];

        discRotationView = [[DiscRotationView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self addSubview:discRotationView];
    }
    return self;
}

- (void) removeObserverFromMusicView {
    // 通知オブジェクトを削除する。
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"trackUrl" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"playing" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pause" object:nil];
}

-(void)setTrackUrl:(NSNotification*)center{
    NSString *value = [[center userInfo] objectForKey:@"trackUrl"];
    DEBUGLOG(@"value:%@", value);
    [self playSound:value];
}

- (void) playing {
    [discRotationView startRotation];
}

- (void) pause {
    [discRotationView stopRotation];
}

- (void)playSound:(NSString *)url {
    [super playSound:url];
}

- (void)pauseSound {
    [super pauseSound];
}

@end