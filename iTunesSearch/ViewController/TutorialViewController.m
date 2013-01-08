//
//  TutorialViewController.m
//  Neiro
//
//  Created by s_akiba on 13/01/08.
//  Copyright (c) 2013年 s_akiba. All rights reserved.
//

#import "TutorialViewController.h"
#import "SideFlipScrollView.h"

@interface TutorialViewController ()

@end

@implementation TutorialViewController
{
    UIButton *btn01;
    UIButton *btn02;
    UIButton *btn03;
    UIButton *btn04;
}

@synthesize tutorialDelegate;

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
    SideFlipScrollView *sideFlipScrollView = [[SideFlipScrollView alloc] init];
    sideFlipScrollView.sideFlipDelegate = self;
    [self.view addSubview:sideFlipScrollView];
    [sideFlipScrollView setView];
    
    btn01 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn02 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn03 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn04 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self setButtons:btn01 :0];
    [self setButtons:btn02 :1];
    [self setButtons:btn03 :2];
    [self setButtons:btn04 :3];
    [btn01 setImage:[UIImage imageNamed:@"blueBtn"] forState:UIControlStateNormal];
    
    UIButton *customView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 30)];
    [customView setBackgroundImage:[UIImage imageNamed:@"cancelBtn"] forState:UIControlStateNormal];
    [customView addTarget:self action:@selector(modalClose) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* buttonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    self.navigationItem.leftBarButtonItem = buttonItem;
}

- (void)modalClose {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)setButtons:(UIButton*)btn:(NSInteger)i {
    [btn setImage:[UIImage imageNamed:@"whiteBtn"] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(110 + i * 30 , 400, 10, 10)];
    [self.view addSubview:btn];
}

- (void) scrolledView:(NSNumber*)pageNumber {
    NSInteger number = [pageNumber integerValue];
    switch (number) {
        case 0:
            [btn01 setImage:[UIImage imageNamed:@"blueBtn"] forState:UIControlStateNormal];
            [btn02 setImage:[UIImage imageNamed:@"whiteBtn"] forState:UIControlStateNormal];
            break;
        case 1:
            [btn01 setImage:[UIImage imageNamed:@"whiteBtn"] forState:UIControlStateNormal];
            [btn02 setImage:[UIImage imageNamed:@"blueBtn"] forState:UIControlStateNormal];
            [btn03 setImage:[UIImage imageNamed:@"whiteBtn"] forState:UIControlStateNormal];
            break;
        case 2:
            [btn02 setImage:[UIImage imageNamed:@"whiteBtn"] forState:UIControlStateNormal];
            [btn03 setImage:[UIImage imageNamed:@"blueBtn"] forState:UIControlStateNormal];
            [btn04 setImage:[UIImage imageNamed:@"whiteBtn"] forState:UIControlStateNormal];
            break;
        case 3:
            [btn03 setImage:[UIImage imageNamed:@"whiteBtn"] forState:UIControlStateNormal];
            [btn04 setImage:[UIImage imageNamed:@"blueBtn"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end