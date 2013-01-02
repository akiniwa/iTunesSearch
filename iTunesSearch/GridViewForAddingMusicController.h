//
//  GridViewForAddingMusicController.h
//  iTunesSearch
//
//  Created by Shinya Akiba on 13/01/02.
//  Copyright (c) 2013年 s_akiba. All rights reserved.
//

#import "GridViewController.h"

@interface GridViewForAddingMusicController : GridViewController

- (void) removeScrollView;
- (void) removeGridView;
- (void) reDrawScrollView:(NSString*)searchKey;

@end
