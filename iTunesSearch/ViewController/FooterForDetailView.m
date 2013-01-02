//
//  FooterForDetailView.m
//  iTunesSearch
//
//  Created by s_akiba on 12/12/27.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "FooterForDetailView.h"
#import "DetailMusicView.h"

@implementation FooterForDetailView
{
    UILabel *footerTitle;
    DetailMusicView *musicView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"footerBackGround"]]];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 150, 20)];
        [label setFont:[UIFont systemFontOfSize:10]];
        [label setTextColor:[UIColor grayColor]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:@"プレイリスト名 :"];
        [self addSubview:label];

        footerTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 180, 40)];
        [footerTitle setBackgroundColor:[UIColor clearColor]];
        [footerTitle setFont:[UIFont systemFontOfSize:19.0f]];
        [self addSubview:footerTitle];

        UIImageView *lineImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line"]];
        [lineImage setFrame:CGRectMake(0, 0, 320, 2)];
        [self addSubview:lineImage];

        musicView = [[DetailMusicView alloc] initWithFrame:CGRectMake(220, 20, 70, 50)];
        musicView.backgroundColor = [UIColor grayColor];
        [self addSubview:musicView];
    }
    return self;
}

- (void)viewWillDisappear {
    [musicView removeObserverFromMusicView];
}

- (void) setTitle:(NSString*)footerString {
    [footerTitle setText:footerString];
}

@end