//
//  AudioPlayer.h
//  Pract
//
//  Created by s_akiba on 12/08/01.
//  Copyright (c) 2012年 早稲田大学. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol AudioPlayerDelegate;

@interface AudioPlayer : NSObject

+ (id)sharedManager;

- (void)playAudioWithData:(NSData *)soundData;
- (void)play;
- (void)pause;
- (BOOL)isPlaying;

@end