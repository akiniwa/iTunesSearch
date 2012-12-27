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
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"backgroundGray"]];

	// Do any additional setup after loading the view.
    detailTableView = [[DetailTableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height - 160) style:UITableViewStylePlain];
    detailTableView.backgroundColor = [UIColor blackColor];
    detailTableView.urlString = [NSString stringWithFormat:@"%@%@", DETAIL_POCKET_URL, pocket_id];
    detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    detailTableView.is_editable = is_editable;
    detailTableView.pocket_id = pocket_id;

    FooterForDetailView *footerForDetailView = [[FooterForDetailView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 160, 320, 100)];
    [footerForDetailView setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:footerForDetailView];

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
        UIButton *addPocket = [UIButton buttonWithType:UIButtonTypeCustom];
        [addPocket setFrame:CGRectMake(140, 5, 80, 40)];
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