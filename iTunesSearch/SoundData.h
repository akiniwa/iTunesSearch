//
//  SoundData.h
//  neiro
//
//  Created by s_akiba on 12/09/07.
//  Copyright (c) 2012年 早稲田大学. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoundData : NSData

@property (nonatomic, retain) NSString *soundTrack;

+(id)sharedInstance;
-(NSData*)cachedSoundForUrl:(NSString*)soundUrl:(NSString*)soundTitle;
-(void)loadSound:(NSString*)soundUrl:(NSString*)soundTitle completion:(void(^)(NSData *soundData))completion;

@end
