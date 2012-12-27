//
//  PublicViewController.m
//  iTunesSearch
//
//  Created by s_akiba on 12/12/10.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "PublicViewController.h"

@interface PublicViewController ()

@end

@implementation PublicViewController

- (void)initialization {
    [super initialization];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.myPocketTableView setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"backgroundGray"]]];
//  [self.myPocketTableView setBackgroundColor:[UIColor lightGrayColor]];
    self.title = @"みんなのプレイリスト";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
