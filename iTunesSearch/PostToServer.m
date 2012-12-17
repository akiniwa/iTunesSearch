//
//  PostTracks.m
//  iTunesSearch
//
//  Created by s_akiba on 12/11/28.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "PostToServer.h"
#import "HttpClient.h"
#import "SBJson.h"

@implementation PostToServer

+ (void)postData:(NSMutableDictionary *)dictionary :(NSURL *)url :(NSString *)postKey{

    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];

    [request setPostValue:[dictionary JSONRepresentation] forKey:postKey];

    [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    [request setDelegate:self];
//    [request setDidFinishSelector:@selector(requestDone:)];
//    [request setDidFailSelector:@selector(requestFailed:)];
    [request startAsynchronous];
    FUNC();
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    
    // Use when fetching binary data
    NSData *responseData = [request responseData];
    
    DEBUGLOG(@"responseString:%@", responseString);
    
}

- (void)requestStarted:(ASIHTTPRequest *)request {
    FUNC();
}

- (void) requestRedirected:(ASIHTTPRequest *)request {
    FUNC();
}

- (void) request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders {
    FUNC();
}

- (void) requestDone:(id)sender {
    NSLog(@"done, sender:%@", [sender class]);
}

- (void) requestFailed:(id)sender {
    NSLog(@"failed, sender:%@", [sender class]);
}

@end