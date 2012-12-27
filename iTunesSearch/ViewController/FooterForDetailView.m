//
//  FooterForDetailView.m
//  iTunesSearch
//
//  Created by s_akiba on 12/12/27.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "FooterForDetailView.h"

@implementation FooterForDetailView
{
    UILabel *footerTitle;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        footerTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 180, 45)];
        [footerTitle setBackgroundColor:[UIColor redColor]];
        [footerTitle setFont:[UIFont systemFontOfSize:14.0f]];
        [self addSubview:footerTitle];
    }
    return self;
}

- (void) setTitle:(NSString*)footerString {
    [footerTitle setText:footerString];
}

@end
