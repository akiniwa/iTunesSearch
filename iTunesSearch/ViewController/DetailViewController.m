//
//  DetailViewController.m
//  iTunesSearch
//
//  Created by s_akiba on 12/12/06.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "DetailViewController.h"
#import "AddPocketViewController.h"
#import "MainViewController.h"

#define DETAIL_POCKET_URL @"http://neiro.me/api/test/detailPocket.php?pocket_id="

@interface DetailViewController (){
    BOOL is_editable;
}

@end

@implementation DetailViewController

@synthesize pocket_id;

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
    detailTableView = [[DetailTableView alloc] initWithFrame:CGRectMake(10, 10, 300, 350) style:UITableViewStyleGrouped];
    detailTableView.urlString = [NSString stringWithFormat:@"%@%@", DETAIL_POCKET_URL, pocket_id];
    detailTableView.is_editable = is_editable;
    detailTableView.pocket_id = pocket_id;

    [self.view addSubview:detailTableView];

    [detailTableView mainTableLoad];
}

- (void) showModal {
    MainViewController *mainViewControllr = [[MainViewController alloc] init];
    mainViewControllr.pocket_id = pocket_id;
    UINavigationController *naviCtr = [[UINavigationController alloc] initWithRootViewController:mainViewControllr];
    mainViewControllr.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:naviCtr animated:YES];
}

- (void)setButton:(BOOL)is_mine {
    if (is_mine) {
        UIButton *addPocket = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [addPocket setFrame:CGRectMake(140, 5, 80, 40)];
        [addPocket setTitle:@"add music" forState:UIControlStateNormal];
        [addPocket addTarget:self action:@selector(showModal) forControlEvents:UIControlEventTouchUpInside];

        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:addPocket];
        self.navigationItem.rightBarButtonItem = rightButton;
        is_editable = YES;
    } else {
        is_editable = NO;
    }
}

@end