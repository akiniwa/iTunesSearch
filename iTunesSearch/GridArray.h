//
//  GridArray.h
//  iTunesSearch
//
//  Created by Shinya Akiba on 13/01/02.
//  Copyright (c) 2013年 s_akiba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GridArray : NSObject

@property (nonatomic, retain) NSMutableArray *artists;
@property (nonatomic, retain) NSMutableArray *jacket_url;
@property (nonatomic, retain) NSMutableArray *views;
@property (nonatomic, retain) NSMutableArray *music_title;
@property (nonatomic, retain) NSMutableArray *track_url;

- (void) removeAllObject;
- (void) removeAtIndex:(NSInteger)index;
- (NSDictionary*) dictionaryAtindex:(NSInteger)index;

@end
