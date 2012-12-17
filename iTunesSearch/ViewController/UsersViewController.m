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

    UIButton *addPocket = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addPocket setFrame:CGRectMake(140, 5, 80, 40)];
    [addPocket setTitle:@"pocket" forState:UIControlStateNormal];
    [addPocket addTarget:self action:@selector(showModal) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:addPocket];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void) showModal {
    AddPocketViewController *addPocketModal = [[AddPocketViewController alloc] init];
    UINavigationController *naviCtr = [[UINavigationController alloc] initWithRootViewController:addPocketModal];
    addPocketModal.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    addPocketModal.addPocketDelegate = self;
    [self presentModalViewController:naviCtr animated:YES];
}

@end