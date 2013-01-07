//
//  UsersViewController.m
//  iTunesSearch
//
//  Created by s_akiba on 12/12/10.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "UsersViewController.h"
#import "AddPocketViewController.h"
#import "UserView.h"

@implementation UsersViewController
{
    UserView *userView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.myPocketTableView setBackgroundColor:[UIColor clearColor]];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"backgroundGray"]];
    [self.myPocketTableView setFrame:CGRectMake(0, 57, 320, self.view.bounds.size.height - 57)];

    UIButton *addPocket = [UIButton buttonWithType:UIButtonTypeCustom];
    [addPocket setFrame:CGRectMake(0, 0, 60, 35)];
    [addPocket setImage:[UIImage imageNamed:@"addPlaylist"] forState:UIControlStateNormal];
    [addPocket addTarget:self action:@selector(showModal) forControlEvents:UIControlEventTouchUpInside];

    userView = [[UserView alloc] initWithFrame:CGRectMake(0, 0, 320, 57)];
    [self.view addSubview:userView];

    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:addPocket];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void) setUserViewTitle:(NSNotification*)center {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    userView.title.text = [NSString stringWithFormat:@"%@%@", [defaults objectForKey:@"name"], @"さんのプレイリスト"];

    int playlistCount = [(NSNumber*)[[center userInfo] objectForKey:@"playlistCount"] intValue];

    if (playlistCount) {
        userView.playlistInfo.text = [NSString stringWithFormat:@"%d%@", playlistCount, @"つのプレイリストが作成されています。"];
    } else {
        userView.playlistInfo.text = @"まだプレイリストが作成されていません。";
    }
}

- (void) viewWillAppear:(BOOL)animated {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(setUserViewTitle:) name:@"playlistCount" object:nil];    
}

- (void) viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"playlistCount" object:nil];
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