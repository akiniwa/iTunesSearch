//
//  UsersViewController.m
//  iTunesSearch
//
//  Created by s_akiba on 12/12/10.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "UsersViewController.h"
#import "AddPocketViewController.h"

@implementation UsersViewController

- (void)initialization {
    [super initialization];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"あなたのプレイリスト";
    [self.myPocketTableView setBackgroundColor:[UIColor clearColor]];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"backgroundGray"]];

    UIButton *addPocket = [UIButton buttonWithType:UIButtonTypeCustom];
    [addPocket setFrame:CGRectMake(140, 5, 60, 40)];
    [addPocket setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    [addPocket addTarget:self action:@selector(showModal) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:addPocket];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void) showModal {
    AddPocketViewController *addPocketModal = [[AddPocketViewController alloc] init];
    UINavigationController *naviCtr = [[UINavigationController alloc] initWithRootViewController:addPocketModal];
    [naviCtr.navigationBar setBackgroundImage:[UIImage imageNamed:@"barNull"] forBarMetrics:UIBarMetricsDefault];
    addPocketModal.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    addPocketModal.addPocketDelegate = self;
    [self presentModalViewController:naviCtr animated:YES];
}

@end