//
//  MainViewController.m
//  iTunesSearch
//
//  Created by s_akiba on 12/10/25.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "GridViewController.h"
#import "GridView.h"
#import "SBJson.h"
#import "HttpClient.h"
#import "MovingScrollView.h"
#import "ScrollView.h"

#define PREVIEW_URL @"http://itunes.apple.com/search?media=music&country=jp&entity=musicTrack&limit=30&term="

@interface GridViewController ()
{
    GridView *gridView;
    UIScrollView *scrollView;
    MovingScrollView *mscroll;
}
@end

@implementation GridViewController

@synthesize artistName;

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
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    scrollView = [[ScrollView alloc] initWithFrame:bounds];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.contentSize = CGSizeMake(320, 700);
    [self.view addSubview:scrollView];

    // GridViewを組み込み。
    gridView = [[GridView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [scrollView addSubview:gridView];

    // 配列を作る。
    [self makeMutableArray];
    // 配列化したviewをGridViewに送る。
//    [self setGridView:array];
}

- (void) makeMutableArray {
    // ここでiTunesから楽曲でーたのjsonを取得する。
    // 与えられたpreviewURLやタイトルなどを送る(NSDictionary?)
    NSString* strURL = [NSString stringWithFormat:@"%@%@",PREVIEW_URL, artistName];
    FUNC();
    // itunesからstatusesをダウンロードするためのURLリクエストを準備
    NSString *encURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:encURL]];
    
    void (^onSuccess)(NSData *) = ^(NSData *data) {
        NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSDictionary *statuses = [json_string JSONValue];
        
        NSMutableArray *info = [statuses objectForKey:@"results"];
        DEBUGLOG(@"%@", info);
        NSMutableDictionary *items = [NSMutableDictionary dictionary];
        
        NSMutableArray *artworks = [NSMutableArray array];
        NSMutableArray *artists = [NSMutableArray array];
        NSMutableArray *views = [NSMutableArray array];
        NSMutableArray *trackNames = [NSMutableArray array];
        
        for (NSDictionary *status in info) {
            [artworks addObject:[status objectForKey:@"artworkUrl100"]];
            [artists addObject:[status objectForKey:@"artistName"]];
            if ([status objectForKey:@"collectionName"]) {
                [trackNames addObject:[status objectForKey:@"collectionName"]];
            } else {
                [trackNames addObject:@""];
            }
            UIView *view = [[UIView alloc] init];
            view.frame = CGRectMake(0, 0, 50, 50);
            
            [views addObject:view];
        }

        [items setObject:artworks forKey:@"artworks"];
        [items setObject:artists forKey:@"artists"];
        [items setObject:trackNames forKey:@"tracks"];
        [items setObject:views forKey:@"views"];
        
        [self performSelectorOnMainThread:@selector(setGridView:) withObject:items waitUntilDone:YES];
    };
    void (^onError)(NSError *) = ^(NSError *error) {
        
    };
    @try {
        [HttpClient request:request success:onSuccess error:onError];
    }
    @catch (NSException *exception) {
        DEBUGLOG(@"%@", exception);
    }
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

// when any button selected.
- (void) setGridView:(NSMutableDictionary*)items
{
    gridView.numberOfColumns = 4;
    [gridView setItems:items];
    [mscroll showView];
}

- (void)setImage{
    [gridView setNeedsDisplay];
    [gridView setNeedsLayout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end