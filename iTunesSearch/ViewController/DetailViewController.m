//
//  DetailViewController.m
//  iTunesSearch
//
//  Created by s_akiba on 12/12/06.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "DetailViewController.h"

#define DETAIL_POCKET_URL @"http://neiro.me/api/test/detailPocket.php?pocket_id="

@interface DetailViewController ()

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
    detailTableView = [[DetailTableView alloc] initWithFrame:CGRectMake(10, 10, 300, 400) style:UITableViewStyleGrouped];
    detailTableView.urlString = [NSString stringWithFormat:@"%@%@", DETAIL_POCKET_URL, pocket_id];

    [self.view addSubview:detailTableView];
    NSLog(@"url:%@", [NSString stringWithFormat:@"%@%@", DETAIL_POCKET_URL, pocket_id]);
    
    [detailTableView mainTableLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end