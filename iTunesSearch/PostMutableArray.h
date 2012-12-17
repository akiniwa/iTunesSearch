//
//  PostMutableArray.h
//  iTunesSearch
//
//  Created by s_akiba on 12/12/04.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostMutableArray : NSObject

@property (nonatomic, retain) NSMutableArray *pocket_id;
@property (nonatomic, retain) NSMutableArray *titles;
@property (nonatomic, retain) NSMutableArray *track_url;
@property (nonatomic, retain) NSMutableArray *jacket_url;
@property (nonatomic, retain) NSMutableArray *artists;

- (void) removeObject:(NSInteger)button_number;

@end