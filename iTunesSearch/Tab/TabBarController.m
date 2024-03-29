//
//  ViewController.m
//  iTunesSearch
//
//  Created by s_akiba on 12/12/06.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "TabBarController.h"
#import "MainViewController.h"
#import "GridViewController.h"
#import "PublicViewController.h"
#import "SettingViewController.h"
#import "UsersViewController.h"

#define PUBLIC_FEED_URL @"http://neiro.me/api/test/publicFeed.php"
#define USER_FEED_URL @"http://neiro.me/api/test/userFeed.php"

@implementation TabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"backgroundGray"]];

    UsersViewController *usersViewController = [[UsersViewController alloc] init];
    usersViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"マイページ" image:[UIImage imageNamed:@"userTab"] tag:0];
    usersViewController.urlString = USER_FEED_URL;
    [usersViewController setShareButton:NO];
    UINavigationController *naviUserPocket = [[UINavigationController alloc] initWithRootViewController:usersViewController];
    [naviUserPocket.navigationBar setBackgroundImage:[UIImage imageNamed:@"barNull"] forBarMetrics:UIBarMetricsDefault];

    PublicViewController *publicViewController = [[PublicViewController alloc] init];
    publicViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"みんなのプレイリスト" image:[UIImage imageNamed:@"publicTab"] tag:1];
    publicViewController.urlString = PUBLIC_FEED_URL;
    [publicViewController setShareButton:YES];
    UINavigationController *naviPublicPocket = [[UINavigationController alloc] initWithRootViewController:publicViewController];
    [naviPublicPocket.navigationBar setBackgroundImage:[UIImage imageNamed:@"barNull"] forBarMetrics:UIBarMetricsDefault];

    SettingViewController *settingViewController = [[SettingViewController alloc] init];
    settingViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"登録情報" image:[UIImage imageNamed:@"settingTab"] tag:2];

    NSArray *viewArray = [NSArray arrayWithObjects:naviUserPocket, naviPublicPocket, settingViewController, nil];
    [self setViewControllers:viewArray animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end