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
#import "FooterForDetailView.h"

#define DETAIL_POCKET_URL @"http://neiro.me/api/test/detailPocket.php?pocket_id="

@interface DetailViewController (){
    BOOL is_editable;
    FooterForDetailView *footerForDetailView;
}

@end

@implementation DetailViewController

@synthesize pocket_id, pocket_title;

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
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"detailBackGround"]];

    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, 50, 30)];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"backPageBtn"]
                          forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(pushBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* buttonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem = buttonItem;

    detailTableView = [[DetailTableView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height - 160) style:UITableViewStylePlain];
    detailTableView.urlString = [NSString stringWithFormat:@"%@%@", DETAIL_POCKET_URL, pocket_id];
    detailTableView.is_editable = is_editable;
    detailTableView.pocket_id = pocket_id;

    [self.view addSubview:detailTableView];
    [detailTableView mainTableLoad];

    footerForDetailView = [[FooterForDetailView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.size.height - 160, self.view.bounds.size.width, 100)];
    [footerForDetailView setTitle:pocket_title];
    [self.view addSubview:footerForDetailView];
}

- (void) showModal {
    MainViewController *mainViewControllr = [[MainViewController alloc] init];
    mainViewControllr.pocket_id = pocket_id;
    UINavigationController *naviCtr = [[UINavigationController alloc] initWithRootViewController:mainViewControllr];
    mainViewControllr.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:naviCtr animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [footerForDetailView viewWillDisappear];
}

- (void)viewDidAppear:(BOOL)animated {
    FUNC();
    [detailTableView mainTableLoad];
}

- (void)pushBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setButton:(BOOL)is_mine {
    if (is_mine) {
        UIButton *addPocket = [UIButton buttonWithType:UIButtonTypeCustom];
        [addPocket setFrame:CGRectMake(0, 0, 60, 35)];
        [addPocket setImage:[UIImage imageNamed:@"addMusic"] forState:UIControlStateNormal];
        [addPocket addTarget:self action:@selector(showModal) forControlEvents:UIControlEventTouchUpInside];

        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:addPocket];
        self.navigationItem.rightBarButtonItem = rightButton;
        is_editable = YES;
    } else {
        is_editable = NO;
    }
}

@end