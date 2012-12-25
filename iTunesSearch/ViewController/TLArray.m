//
//  TLArray.m
//  iTunesSearch
//
//  Created by s_akiba on 12/12/06.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "TLArray.h"

@implementation TLArray

@synthesize artists, music_title, user_name, pocket_title, shared, jacket_url, pocket_id, user_id, music_count;

- (id)init {
    self = [super init];
    if (self) {
        artists = [NSMutableArray array];
        music_title = [NSMutableArray array];
        user_name = [NSMutableArray array];
        pocket_title = [NSMutableArray array];
        shared = [NSMutableArray array];
        jacket_url = [NSMutableArray array];
        pocket_id = [NSMutableArray array];
        user_id = [NSMutableArray array];
        music_count = [NSMutableArray array];
    }
    return self;
}

- (void)removeAllObject {
    [artists removeAllObjects];
    [music_title removeAllObjects];
    [user_name removeAllObjects];
    [pocket_title removeAllObjects];
    [shared removeAllObjects];
    [jacket_url removeAllObjects];
    [pocket_id removeAllObjects];
    [user_id removeAllObjects];
    [music_count removeAllObjects];
}

- (void) removeAtIndexPath:(NSInteger)indexPath {
//  [artists removeObjectAtIndex:indexPath];
    [music_title removeObjectAtIndex:indexPath];
    [user_name removeObjectAtIndex:indexPath];
    [pocket_title removeObjectAtIndex:indexPath];
    [shared removeObjectAtIndex:indexPath];
    [jacket_url removeObjectAtIndex:indexPath];
    [pocket_id removeObjectAtIndex:indexPath];
    [user_id removeObjectAtIndex:indexPath];
    [music_count removeObjectAtIndex:indexPath];
}

@end