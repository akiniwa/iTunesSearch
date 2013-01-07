//
//  AudioPlayer.m
//  Pract
//
//  Created by s_akiba on 12/08/01.
//  Copyright (c) 2012年 早稲田大学. All rights reserved.
//

#import "AudioPlayer.h"

static id theSharedManager = nil;

@implementation AudioPlayer
{
    AVAudioPlayer *player;
}

+ (id)sharedManager
{
    if (theSharedManager == nil)
    {
        theSharedManager = [[self alloc] init];
    }
//    [[AVAudioSession sharedInstance] setDelegate: self];
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:NULL];
    return theSharedManager;
}

- (void)playAudioWithData:(NSData *)soundData
{
        if (player)
        {
            [player pause];
        }
    player = [[AVAudioPlayer alloc] initWithData:soundData error:nil];
}

- (BOOL) isPlaying {
    return [player isPlaying];
}

- (void)play
{
    if (player) 
    {
        [player play];
        NSNotification *n = [NSNotification notificationWithName:@"playing" object:self];
        [[NSNotificationCenter defaultCenter] postNotification:n];
    }
}

- (void)pause
{
    if (player) 
    {
        [player pause];
        NSNotification *n = [NSNotification notificationWithName:@"pause" object:self];
        [[NSNotificationCenter defaultCenter] postNotification:n];
    }
}

@end