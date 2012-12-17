//
//  TLArray.m
//  iTunesSearch
//
//  Created by s_akiba on 12/12/06.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "TLArray.h"

@implementation TLArray

@synthesize artists, music_title, user_name, pocket_title, shared, jacket_url, pocket_id, user_id;

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
}

@end