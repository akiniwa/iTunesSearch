//
//  GridView.h
//  iTunesSearch
//
//  Created by s_akiba on 12/10/25.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridView : UIView
{
    NSUInteger numberOfColumns;
    NSMutableDictionary *items;
}

@property (nonatomic, assign) NSUInteger numberOfColumns;

- (void)setItems:(NSMutableDictionary *)value;

@end
