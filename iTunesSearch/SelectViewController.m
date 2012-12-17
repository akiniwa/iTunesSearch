//
//  SelectViewController.m
//  iTunesSearch
//
//  Created by s_akiba on 12/10/25.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "SelectViewController.h"
#import "MainViewController.h"
#import "GridViewController.h"
#import "SelectTable.h"

@interface SelectViewController ()

@end

@implementation SelectViewController

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

    UIButton *mainBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [mainBtn setTitle:@"横スライド" forState:UIControlStateNormal];
    [mainBtn addTarget:self action:@selector(pushMainView) forControlEvents:UIControlEventTouchUpInside];
    mainBtn.frame = CGRectMake(50, 50, 150, 100);
    [self.view addSubview:mainBtn];

    SelectTable *table = [[SelectTable alloc] initWithFrame:CGRectMake(0, 200, 320, 250)];
    table.gridDelegate = self;
    [self.view addSubview:table];
}

- (void) pushMainView {
    MainViewController *controller = [[MainViewController alloc] init];
    [[self navigationController] pushViewController:controller animated:YES];
}

- (void) pushGridView:(NSString*)artistName {
    GridViewController *controller = [[GridViewController alloc] init];
    controller.artistName = artistName;
    [[self navigationController] pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end