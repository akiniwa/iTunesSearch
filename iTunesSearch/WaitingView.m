//
//  WaitingView.m
//  Neiro
//
//  Created by s_akiba on 13/01/08.
//  Copyright (c) 2013年 s_akiba. All rights reserved.
//

#import "WaitingView.h"

@implementation WaitingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Default"]];
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [spinner setBackgroundColor:[UIColor clearColor]];
        [spinner setCenter:self.center];
        [self addSubview:spinner];
        [spinner startAnimating];
        
        UILabel *label = [[UILabel alloc] init];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor whiteColor]];
        [label setFrame:CGRectMake(55, self.frame.size.height - 180, 240, 40)];
        label.numberOfLines = 2;
        [label setText:@"ログイン処理中\nしばらくお待ちください。"];
        [self addSubview:label];
    }
    return self;
}

@end
