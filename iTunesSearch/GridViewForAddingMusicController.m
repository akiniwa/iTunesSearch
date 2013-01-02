//
//  GridViewForAddingMusicController.m
//  iTunesSearch
//
//  Created by Shinya Akiba on 13/01/02.
//  Copyright (c) 2013年 s_akiba. All rights reserved.
//

#import "GridViewForAddingMusicController.h"

@interface GridViewForAddingMusicController ()

@end

@implementation GridViewForAddingMusicController

- (void) notificateNumbers:(NSMutableDictionary*)dictionary {
    [self.gridViewDelegate performSelector:@selector(notificateNumbers:) withObject:dictionary];
}

@end