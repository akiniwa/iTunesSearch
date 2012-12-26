//
//  MusicView.m
//  iTunesSearch
//
//  Created by s_akiba on 12/12/26.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "MusicView.h"

@implementation MusicView

@synthesize playButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        soundData = [SoundData sharedInstance];
        audioPlayer = [AudioPlayer sharedManager];
        // URLがキーになっているキャッシュのデータを取得しにいき、なければロードする。
    }
    return self;
}

- (void)playSound:(NSString*)url {
    if ([soundData cachedSoundForUrl:url :@"title"]) {
        [self sendDataForPlaying:[soundData cachedSoundForUrl:url :@"title"]];
    } else {
        [soundData loadSound:url :@"title" completion:^(NSData *loadData) {
            [self performSelectorOnMainThread:@selector(loadSoundData:) withObject:loadData waitUntilDone:YES];
        }];
    }
}

- (BOOL)is_playing {
    return [audioPlayer isPlaying];
}

- (void)pauseSound {
    [audioPlayer pause];
}

- (void) loadSoundData:(NSData*)loadData {
    [self sendDataForPlaying:loadData];
}

- (void) sendDataForPlaying:(NSData*)data {
    [audioPlayer playAudioWithData:data];
    [audioPlayer play];
}

@end