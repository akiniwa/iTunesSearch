//
//  MyPocketViewController.m
//  iTunesSearch
//
//  Created by s_akiba on 12/12/06.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "MyPocketViewController.h"
#import "DetailViewController.h"

@implementation MyPocketViewController

@synthesize myPocketTableView, urlString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
       
    }
    return self;
}

- (void)initialization {
    myPocketTableView = [[MyPocketTableView alloc] initWithFrame:CGRectMake(10, 10, 300, 360) style:UITableViewStyleGrouped];
    myPocketTableView.urlString = self.urlString;
    myPocketTableView.myPocketDelegate = self;
    [self.view addSubview:myPocketTableView];
}

- (void)setShareButton:(BOOL)is_button {
    myPocketTableView.is_button = is_button;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [myPocketTableView mainTableLoad];

    UIButton *addPocket = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addPocket setFrame:CGRectMake(140, 5, 80, 40)];
    [addPocket setTitle:@"reload" forState:UIControlStateNormal];
    [addPocket addTarget:myPocketTableView action:@selector(reloadTable) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:addPocket];
    self.navigationItem.leftBarButtonItem = leftButton;
}

- (void) pushToDetailView:(NSString*)pocket_id:(NSString*)button_string {

    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    detailViewController.pocket_id = pocket_id;
    if ([button_string isEqualToString:@"YES"]) {
        [detailViewController setButton:YES];
    } else {
        [detailViewController setButton:NO];
    }
    [self.navigationController pushViewController:detailViewController animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end