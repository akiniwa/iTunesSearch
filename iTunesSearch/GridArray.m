//
//  GridArray.m
//  iTunesSearch
//
//  Created by Shinya Akiba on 13/01/02.
//  Copyright (c) 2013年 s_akiba. All rights reserved.
//

#import "GridArray.h"

@implementation GridArray

@synthesize artists, jacket_url, views, music_title, track_url;

- (id)init {
    self = [super init];
    if (self) {
        artists = [NSMutableArray array];
        jacket_url = [NSMutableArray array];
        views = [NSMutableArray array];
        music_title = [NSMutableArray array];
        track_url = [NSMutableArray array];
    }
    return self;
}

- (void)removeAllObject {
    [artists removeAllObjects];
    [jacket_url removeAllObjects];
    [views removeAllObjects];
    [music_title removeAllObjects];
    [track_url removeAllObjects];
}

- (void)removeAtIndex:(NSInteger)index {
    [artists removeObjectAtIndex:index];
    [jacket_url removeObjectAtIndex:index];
    [views removeObjectAtIndex:index];
    [music_title removeObjectAtIndex:index];
    [track_url removeObjectAtIndex:index];
}

- (NSDictionary*)dictionaryAtindex:(NSInteger)index {
    NSDictionary *dictionary = @{@"artist" : [artists objectAtIndex:index],
    @"jacket_url" : [jacket_url objectAtIndex:index],
    @"views" : [views objectAtIndex:index],
    @"music_title" : [music_title objectAtIndex:index],
    @"track_url" : [track_url objectAtIndex:index]};

    return dictionary;
}

@end
