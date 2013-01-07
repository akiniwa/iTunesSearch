//
//  MusicSearchTextField.m
//  iTunesSearch
//
//  Created by s_akiba on 13/01/07.
//  Copyright (c) 2013年 s_akiba. All rights reserved.
//

#import "MusicSearchTextField.h"

@implementation MusicSearchTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect inset = CGRectMake(bounds.origin.x + 6, bounds.origin.y + 6, bounds.size.width - 6, bounds.size.height - 6);
    return inset;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect inset = CGRectMake(bounds.origin.x + 6, bounds.origin.y + 6, bounds.size.width - 6, bounds.size.height - 6);
    return inset;
}
@end
