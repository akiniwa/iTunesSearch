//
//  SideFlipViewController.m
//  Neiro
//
//  Created by s_akiba on 13/01/08.
//  Copyright (c) 2013年 s_akiba. All rights reserved.
//

#import "SideFlipScrollView.h"

@implementation SideFlipScrollView
{
    UIButton *pageNaviButton;
}
@synthesize sideFlipDelegate;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setFrame:CGRectMake(0, 0, 320, 420)];
    }
    return self;
}

- (void)setView {
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.scrollsToTop = NO;
    self.delegate = (id)self;
    self.contentSize = CGSizeMake(320.0 * PAGE_COUNT, 420.0f);
    self.pagingEnabled = YES;
    self.bounces = NO;

    for (int i = 0; i < PAGE_COUNT; i++) {
        NSString *str = [NSString stringWithFormat:@"%@%d%@", @"tutorial0", i+1, @".png"];
        UIImageView * imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:str]];
        imgView.frame = CGRectMake(320.0f * i + 10, 0, 300, 300 * 1.33);
        [self addSubview:imgView];
    }
}

- (void) endScroll {
    NSUInteger page = (NSUInteger)((self.contentOffset.x + 160)/ self.bounds.size.width);
    switch (page) {
        case 3:
            [sideFlipDelegate performSelector:@selector(scrolledView:) withObject:[NSNumber numberWithInteger:page]];
            break;
        default:
            [sideFlipDelegate performSelector:@selector(scrolledView:) withObject:[NSNumber numberWithInteger:page]];
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self endScroll];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    [self endScroll];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
//    [self endScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self endScroll];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self endScroll];
}

@end
