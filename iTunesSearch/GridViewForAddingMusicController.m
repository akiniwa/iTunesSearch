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

- (void) removeScrollView {
    [scrollView removeFromSuperview];
}

- (void) removeGridView {
    [gridView removeFromSuperview];
}

- (void) reDrawScrollView:(NSString*)searchKey {
    self.artistName = searchKey;
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 95, bounds.size.width, bounds.size.height)];
    
    postMutableArray = [[PostMutableArray alloc] init];
    
    gridView = [[GridView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height)];
    gridView.backgroundColor = [UIColor clearColor];
    gridView.delegateGridView = self;
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height - 60)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.contentSize = CGSizeMake(bounds.size.width, bounds.size.height + 120);
    [self.view addSubview:scrollView];

    [scrollView addSubview:gridView];
    [self makeMutableArray];
}

@end