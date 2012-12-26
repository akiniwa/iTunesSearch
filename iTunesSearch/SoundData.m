//
//  SoundData.m
//  neiro
//
//  Created by s_akiba on 12/09/07.
//  Copyright (c) 2012年 早稲田大学. All rights reserved.
//

#import "SoundData.h"

@interface SoundData() {
    NSOperationQueue *_networkQueue;
    NSCache *_soundCache;
    NSCache *_requestingUrls;
}
@end

@implementation SoundData

@synthesize soundTrack;

+(id)sharedInstance {
    // sharedInstanceを呼ぶことで、
    static SoundData *soundData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        soundData = [[self alloc] init];
    });
    return soundData;
}

-(id)init{
    self = [super init];
    if (self) {
        _networkQueue = [[NSOperationQueue alloc] init];
        _requestingUrls = [[NSCache alloc] init]; // ただの便利なマルチスレッド用Dictionaryとして使っている
        
        _soundCache = [[NSCache alloc] init];
    }
    return self;
}

-(NSData *)cachedSoundForUrl:(NSString *)soundUrl:(NSString*)soundTitle {
    soundTrack = soundTitle;
    return [_soundCache objectForKey:soundUrl];
}

-(void)loadSound:(NSString *)soundUrl :(NSString *)soundTitle completion:(void (^)(NSData *))completion {
    soundTrack = soundTitle;
    if ([_requestingUrls objectForKey:soundUrl]) {
        return;
    }
    
    [_requestingUrls setObject:soundTitle forKey:soundUrl];
    // 音楽をロード
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:soundUrl] 
                                         cachePolicy:NSURLCacheStorageNotAllowed 
                                     timeoutInterval:20];
    
    NSCache *weakedSoundCache = _soundCache;
    NSCache *weakedRequestingURL = _requestingUrls;
    
    [NSURLConnection sendAsynchronousRequest:req queue:_networkQueue 
                           completionHandler:^(NSURLResponse *res, NSData *soundData, NSError *error) 
    {
        NSData *data = [NSData dataWithData:soundData];
        
        [weakedSoundCache setObject:data forKey:soundUrl];
        
        [weakedRequestingURL removeObjectForKey:soundUrl];
        completion(data);
    }];
}

@end
