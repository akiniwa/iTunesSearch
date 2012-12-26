//
//  MusicView.h
//  iTunesSearch
//
//  Created by s_akiba on 12/12/26.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioPlayer.h"
#import "SoundData.h"

@interface MusicView : UIView
{
    AudioPlayer *audioPlayer;
    SoundData *soundData;
}

@property (nonatomic, retain) UIButton *playButton;

- (void)playSound:(NSString*)url;
- (void)pauseSound;
- (BOOL)is_playing;

@end