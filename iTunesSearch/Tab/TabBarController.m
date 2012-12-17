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
#import "MyPocketViewController.h"
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
    UINavigationController *naviUser = [[UINavigationController alloc] initWithRootViewController:usersViewController];
    
    MyPocketViewController *pocketViewController = [[MyPocketViewController alloc] init];
    pocketViewController.urlString = POCKET_FEED_URL;
    pocketViewController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:1];
    [pocketViewController initialization];
    UINavigationController *naviMyPocket = [[UINavigationController alloc] initWithRootViewController:pocketViewController];
    
    MainViewController *mainViewController = [[MainViewController alloc] init];
    mainViewController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:2];
    
    SettingViewController *settingViewController = [[SettingViewController alloc] init];
    settingViewController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:3];

    NSArray *viewArray = [NSArray arrayWithObjects:naviUser, naviMyPocket, mainViewController, settingViewController, nil];
    [self setViewControllers:viewArray animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end