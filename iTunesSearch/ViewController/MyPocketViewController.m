//
//  MyPocketViewController.m
//  iTunesSearch
//
//  Created by s_akiba on 12/12/06.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "MyPocketViewController.h"
#import "DetailViewController.h"
#import "UITabBarController+hidable.h"

@interface MyPocketViewController()
{
    BOOL is_reloading;
    UILabel *triggerHeader;
    BOOL headerOn;
    
    BOOL hidden;
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
    myPocketTableView = [[MyPocketTableView alloc] initWithFrame:CGRectMake(0, 0, 320, (int)self.view.bounds.size.height) style:UITableViewStylePlain];
    myPocketTableView.urlString = self.urlString;
    myPocketTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myPocketTableView.myPocketDelegate = self;
    [self.view addSubview:myPocketTableView];

}

- (void)setShareButton:(BOOL)is_button {
    myPocketTableView.is_button = is_button;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialization];
    [self setTrigger];
    [myPocketTableView mainTableLoad];
}

- (void) pushToDetailView:(NSDictionary*)dictionary {
    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    detailViewController.pocket_id = [dictionary objectForKey:@"pocket_id"];
    detailViewController.pocket_title = [dictionary objectForKey:@"pocket_title"];

    if ([[dictionary objectForKey:@"is_mine"] isEqualToString:@"YES"]) {
        [detailViewController setButton:YES];
    } else {
        [detailViewController setButton:NO];
    }
    [self.navigationController setNavigationBarHidden:NO
                                             animated:NO];
    [self.tabBarController setTabBarHidden:NO
                                  animated:NO];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void) viewDidAppear:(BOOL)animated {
    [myPocketTableView reloadTable];
}

- (void)setTrigger{
    //トリガーのイメージを埋め込む。
    CGRect r = myPocketTableView.bounds;
    r.origin.y -= 70;
    r.size.height = 70;
    triggerHeader = [[UILabel alloc] initWithFrame:r];

    [triggerHeader setBackgroundColor:[UIColor clearColor]];
    [myPocketTableView addSubview:triggerHeader];

    UIImageView* imageview = [[UIImageView alloc] initWithFrame:CGRectMake((r.size.width/2 - 30), (60 - 32) / 2, 45, 32)];
    imageview.image = [UIImage imageNamed:@"downward"];
    imageview.tag = 1;
    [triggerHeader addSubview:imageview];
    is_reloading = NO;
}

-(void)hideMusicView {
    //トリガーは追加。
    CGRect r = myPocketTableView.bounds;
    if (r.origin.y < -70) {
		UIImageView* imageview = (UIImageView*)[triggerHeader viewWithTag:1];
		[UIView beginAnimations:nil context:nil];
        //CGAffineTransformRotate:回転
		imageview.transform = CGAffineTransformRotate(CGAffineTransformIdentity, 3.14);
		[UIView commitAnimations];
        if (!is_reloading){
            is_reloading = YES;
            [myPocketTableView reloadTable];
        }
	}
	if (r.origin.y > -70) {
		UIImageView* imageview = (UIImageView*)[triggerHeader viewWithTag:1];
		[UIView beginAnimations:nil context:nil];
        //CGAffineTransformIdentity:オリジナルのアフィンに戻す。
		imageview.transform = CGAffineTransformIdentity;
		[UIView commitAnimations];
    }
}

- (void)showMusicView {
    
}

- (void) didReload {
    is_reloading = NO;
}

-(void)expand
{
    if(hidden)
        return;
    
    hidden = YES;
    
    [self.tabBarController setTabBarHidden:YES
                                  animated:YES];
    
    [self.navigationController setNavigationBarHidden:YES
                                             animated:YES];
}

-(void)contract
{
    if(!hidden)
        return;

    hidden = NO;

    [self.tabBarController setTabBarHidden:NO
                                  animated:YES];
    
    [self.navigationController setNavigationBarHidden:NO
                                             animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end