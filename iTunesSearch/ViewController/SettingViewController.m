//
//  SettingViewController.m
//  iTunesSearch
//
//  Created by s_akiba on 12/12/10.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableView.h"
#import "TutorialViewController.h"

@implementation SettingViewController
{
    SettingTableView *settingTable;
}

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
    
    CGRect r = self.view.bounds;
    settingTable = [[SettingTableView alloc] initWithFrame:CGRectMake(r.origin.x, r.origin.y, r.size.width, r.size.height - 49) style:UITableViewStyleGrouped];
    settingTable.settingTableDelegate = self;
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"backgroundGray"]];
    [self.view addSubview:settingTable];
}

- (void)viewWillAppear:(BOOL)animated {
    [settingTable reloadData];
}

- (void)showTutorialView {
    TutorialViewController *addPocketModal = [[TutorialViewController alloc] init];
    UINavigationController *naviCtr = [[UINavigationController alloc] initWithRootViewController:addPocketModal];
    [naviCtr.navigationBar setBackgroundImage:[UIImage imageNamed:@"barNull"] forBarMetrics:UIBarMetricsDefault];
    addPocketModal.modalTransitionStyle = UIModalTransitionStyleCoverVertical;

    [self presentModalViewController:naviCtr animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
