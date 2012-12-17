//
//  TLArray.h
//  iTunesSearch
//
//  Created by s_akiba on 12/12/06.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLArray : NSObject

@property (nonatomic, retain) NSMutableArray *music_title;
@property (nonatomic, retain) NSMutableArray *artists;
@property (nonatomic, retain) NSMutableArray *pocket_id;
@property (nonatomic, retain) NSMutableArray *pocket_title;
@property (nonatomic, retain) NSMutableArray *user_id;
@property (nonatomic, retain) NSMutableArray *user_name;
@property (nonatomic, retain) NSMutableArray *shared;
@property (nonatomic, retain) NSMutableArray *jacket_url;


- (void) removeAllObject;

@end
