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

- (void)postData:(NSMutableDictionary *)dictionary :(NSURL *)url :(NSString *)postKey{

    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];

    [request setPostValue:[dictionary JSONRepresentation] forKey:postKey];
    DEBUGLOG(@"dictionay:%@", dictionary);
    [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    [request setDelegate:self];

//    [request startAsynchronous];
    [request startSynchronous];
    FUNC();
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    FUNC();
    // Use when fetching text data
    NSString *responseString = [request responseString];

    DEBUGLOG(@"responseString:%@", responseString);
}

- (void)requestStarted:(ASIHTTPRequest *)request {
    FUNC();
}

- (void) requestRedirected:(ASIHTTPRequest *)request {
    FUNC();
}

- (void) request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders {
    NSDictionary *dictionay = [request responseHeaders];
    int i = [request responseStatusCode];
    DEBUGLOG(@"statuscode:%d", i);
    DEBUGLOG(@"responseHeaders:%@", dictionay);
}

- (void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL {
    FUNC();
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    FUNC();
}

- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data {
    FUNC();
}

- (void)authenticationNeededForRequest:(ASIHTTPRequest *)request {
    FUNC();
}

- (void)proxyAuthenticationNeededForRequest:(ASIHTTPRequest *)request {
    FUNC();
}


@end