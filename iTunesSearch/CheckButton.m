//
//  CheckButton.m
//  iTunesSearch
//
//  Created by s_akiba on 12/11/28.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "CheckButton.h"

@implementation CheckButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        is_checked = NO;
        // Initialization code
    }
    return self;
}

- (void)setCheckButton {
    if (!view) {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(30, 30, 35, 35)];
        view.image = [UIImage imageNamed:@"check.png"];
    }
    if (is_checked) {
        [view removeFromSuperview];
        is_checked = NO;
    } else {
        [self addSubview:view];
        is_checked = YES;
    }
}

- (BOOL)confirmIsChecked {
    if (is_checked) {
        return YES;
    } else {
        return NO;
    }
}



@end
