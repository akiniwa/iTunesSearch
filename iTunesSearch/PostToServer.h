//
//  PostTracks.h
//  iTunesSearch
//
//  Created by s_akiba on 12/11/28.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

@interface PostToServer : NSObject <ASIHTTPRequestDelegate>

+ (void)postData:(NSMutableDictionary*)dictionary:(NSURL*)url:(NSString*)postKey;

@end