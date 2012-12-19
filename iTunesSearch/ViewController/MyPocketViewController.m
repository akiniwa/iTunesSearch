//
//  MyPocketViewController.m
//  iTunesSearch
//
//  Created by s_akiba on 12/12/06.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "MyPocketViewController.h"
#import "DetailViewController.h"

@interface MyPocketViewController()
{
    BOOL is_reload;
}

@end

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

-(void)hideMusicView {
    //トリガーは追加。
    CGRect r = myPocketTableView.bounds;
    if (r.origin.y > -70) {
        triggerHeader.text = @"引っ張って…";
    } else {
        triggerHeader.text = @"離して更新!!";
        if (is_reload){
            is_reload = NO;
        }
    }
    if ((r.origin.y < -70) && (is_reload == NO)) {
		is_reload = YES;
		UIImageView* imageview = (UIImageView*)[triggerHeader viewWithTag:1];
		[UIView beginAnimations:nil context:nil];
        //CGAffineTransformRotate:回転
		imageview.transform = CGAffineTransformRotate(CGAffineTransformIdentity, 3.14);
		[UIView commitAnimations];
	}
	if ((r.origin.y > -70) && (is_reload == YES)) {
		is_reload = NO;
		UIImageView* imageview = (UIImageView*)[triggerHeader viewWithTag:1];
		[UIView beginAnimations:nil context:nil];
        //CGAffineTransformIdentity:オリジナルのアフィンに戻す。
		imageview.transform = CGAffineTransformIdentity;
		[UIView commitAnimations];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end