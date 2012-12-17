//
//  PostMutableArray.m
//  iTunesSearch
//
//  Created by s_akiba on 12/12/04.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "PostMutableArray.h"

@implementation PostMutableArray

@synthesize pocket_id, titles, track_url, jacket_url, artists;

- (id) init {
    self = [super init];
    if (self != nil) {
//      pocket_id = [NSMutableArray array];
        titles = [NSMutableArray array];
        track_url = [NSMutableArray array];
        jacket_url = [NSMutableArray array];
        artists = [NSMutableArray array];
    }
    return self;
}

- (void)removeAllObjects:(NSInteger)button_number {
//  [self removeObjectAtIndex:pocket_id :button_number];
    [self removeObjectAtIndex:titles :button_number];
    [self removeObjectAtIndex:track_url :button_number];
    [self removeObjectAtIndex:jacket_url :button_number];
    [self removeObjectAtIndex:artists :button_number];
}

- (void) removeObjectAtIndex:(NSMutableArray*)mutableArray:(NSInteger)indexNumber{
    [mutableArray removeObjectAtIndex:indexNumber];
    FUNC();
}

@end
