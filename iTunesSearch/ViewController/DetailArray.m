//
//  DetailArray.m
//  iTunesSearch
//
//  Created by s_akiba on 12/12/10.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "DetailArray.h"

@implementation DetailArray

@synthesize artists, music_title, jacket_url, track_url;

- (id)init {
    self = [super init];
    if (self) {
        artists = [NSMutableArray array];
        music_title = [NSMutableArray array];
        track_url = [NSMutableArray array];
        jacket_url = [NSMutableArray array];
    }
    return self;
}

- (void)removeAllObject {
    [artists removeAllObjects];
    [music_title removeAllObjects];
    [track_url removeAllObjects];
    [jacket_url removeAllObjects];
}

@end
