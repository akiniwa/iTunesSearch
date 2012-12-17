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

#define POCKET_FEED_URL @"http://neiro.me/api/test/pocketFeed.php"
#define MYPOCKET_FEED_URL @"http://neiro.me/api/test/myPocket.php"

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
	// Do any additional setup after loading the view.
    UsersViewController *usersViewController = [[UsersViewController alloc] init];
    usersViewController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:0];
    usersViewController.urlString = MYPOCKET_FEED_URL;
    [usersViewController initialization];
    [usersViewController setShareButton:NO];
    UINavigationController *naviUserPocket = [[UINavigationController alloc] initWithRootViewController:usersViewController];

    PublicViewController *publicViewController = [[PublicViewController alloc] init];
    publicViewController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:0];
    publicViewController.urlString = POCKET_FEED_URL;
    [publicViewController initialization];
    [publicViewController setShareButton:YES];
    UINavigationController *naviPublicPocket = [[UINavigationController alloc] initWithRootViewController:publicViewController];

    MainViewController *mainViewController = [[MainViewController alloc] init];
    mainViewController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:2];

    SettingViewController *settingViewController = [[SettingViewController alloc] init];
    settingViewController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:3];

    NSArray *viewArray = [NSArray arrayWithObjects:naviUserPocket, naviPublicPocket, mainViewController, settingViewController, nil];
    [self setViewControllers:viewArray animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end