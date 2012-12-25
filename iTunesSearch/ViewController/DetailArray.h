//
//  DetailArray.h
//  iTunesSearch
//
//  Created by s_akiba on 12/12/10.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailArray : NSObject

@property (nonatomic, retain) NSMutableArray *music_title;
@property (nonatomic, retain) NSMutableArray *artists;
@property (nonatomic, retain) NSMutableArray *jacket_url;
@property (nonatomic, retain) NSMutableArray *track_url;
@property (nonatomic, retain) NSMutableArray *music_id;

- (void) removeAllObject;
- (void) removeAtIndex:(NSInteger)index;

@end