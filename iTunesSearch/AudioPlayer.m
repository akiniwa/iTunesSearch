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
    NSNotification *notification;
    NSNotificationCenter *center;
}

+ (id)sharedManager
{
    if (theSharedManager == nil)
    {
        theSharedManager = [[self alloc] init];
    }
    return theSharedManager;
}

- (void)playAudioWithData:(NSData *)soundData
{
        if (player)
        {
            [player pause];
        }
        player = [[AVAudioPlayer alloc] initWithData:soundData error:nil];
        // logister to notificationCenter.
        }

- (BOOL) isPlaying {
    return [player isPlaying];
}

- (void)play
{
    if (player) 
    {
        [player play];
        notification = [NSNotification notificationWithName:@"playingStatusChanged" object:@"play" userInfo:nil];
        center = [NSNotificationCenter defaultCenter];
        [center postNotification:notification];
    }
}

- (void)pause
{
    if (player) 
    {
        [player pause];
        notification = [NSNotification notificationWithName:@"playingStatusChanged" object:@"pause" userInfo:nil];
        center = [NSNotificationCenter defaultCenter];
        [center postNotification:notification];
    }
}

@end