//
//  MainViewController.m
//  iTunesSearch
//
//  Created by s_akiba on 12/10/25.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "GridViewController.h"
#import "SBJson.h"
#import "HttpClient.h"
#import "ScrollView.h"
#import "PostMutableArray.h"

#define PREVIEW_URL @"http://itunes.apple.com/search?media=music&country=jp&entity=song&limit=24&term="

@interface GridViewController ()
{
    UIScrollView *scrollView;
    
    PostMutableArray *postMutableArray;
    NSMutableDictionary *selectDictionary;
    NSMutableDictionary *items;
}
@end

@implementation GridViewController

@synthesize artistName, gridViewDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super init];
    if (self) {
        self.view.frame = frame;
        // Do your init stuff here
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGRect bounds = [[UIScreen mainScreen] bounds];
    scrollView = [[ScrollView alloc] initWithFrame:bounds];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:scrollView];

    postMutableArray = [[PostMutableArray alloc] init];

    gridView = [[GridView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height)];
    gridView.backgroundColor = [UIColor clearColor];
    gridView.delegateGridView = self;
    [scrollView addSubview:gridView];

    UIButton *barButtom = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [barButtom setFrame:CGRectMake(0, 0, 55, 30)];
    [barButtom setTitle:@"選択する" forState:UIControlStateNormal];
    [barButtom addTarget:self action:@selector(selectedMusic) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithCustomView:barButtom];
    self.navigationItem.rightBarButtonItem = rightButton;

    // 配列を作る。
    [self makeMutableArray];
}

- (void) viewDidAppear:(BOOL)animated {
}

- (void) selectedMusic {
    // mainviewcontrollerに選択した曲を知らせる。
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:postMutableArray.artists forKey:@"artists"];
    [dictionary setObject:postMutableArray.titles forKey:@"titles"];
    [dictionary setObject:postMutableArray.track_url forKey:@"track_url"];
    [dictionary setObject:postMutableArray.jacket_url forKey:@"jacket_url"];
    [gridViewDelegate performSelector:@selector(setArray:) withObject:dictionary];

    [self.navigationController popViewControllerAnimated:YES];
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
        items = [NSMutableDictionary dictionary];

        NSMutableArray *jacket_url = [NSMutableArray array];
        NSMutableArray *artists = [NSMutableArray array];
        NSMutableArray *views = [NSMutableArray array];
        NSMutableArray *titles = [NSMutableArray array];
        NSMutableArray *track_url = [NSMutableArray array];
        
        for (NSDictionary *status in info) {
            [jacket_url addObject:[status objectForKey:@"artworkUrl100"]];
            [artists addObject:[status objectForKey:@"artistName"]];
            [track_url addObject:[status objectForKey:@"previewUrl"]];
            if ([status objectForKey:@"trackName"]) {
                [titles addObject:[status objectForKey:@"trackName"]];
            } else {
                [titles addObject:@""];
            }
            UIView *view = [[UIView alloc] init];
            view.frame = CGRectMake(0, 0, 50, 50);

            [views addObject:view];
        }

        [items setObject:jacket_url forKey:@"jacket_url"];
        [items setObject:track_url forKey:@"track_url"];
        [items setObject:artists forKey:@"artists"];
        [items setObject:titles forKey:@"titles"];
        [items setObject:views forKey:@"views"];

        int height = (([titles count]+3)/4)*96;
        NSLog(@"height::%d", height);
        scrollView.contentSize = CGSizeMake(320, (height + 75));
        gridView.frame = CGRectMake(0, 0, 320, height);
 
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

- (void) notificateNumbers:(NSMutableDictionary*)dictionary {
    NSInteger button_number = [[dictionary objectForKey:@"button_number"] intValue];
    NSString *is_checked = [dictionary objectForKey:@"is_checked"];

    if ([is_checked isEqualToString:@"NO"]) {
        [self removePostMutableArray:button_number];
    } else {
        [selectDictionary setObject:[NSString stringWithFormat:@"%d", [postMutableArray.titles count]] forKey:[NSString stringWithFormat:@"%d", button_number]];
        [self addPostMutableArray :button_number];
    }
}

- (void) addPostMutableArray:(NSInteger)button_number {
    [postMutableArray.titles addObject:[[items objectForKey:@"titles"] objectAtIndex:button_number]];
    [postMutableArray.track_url addObject:[[items objectForKey:@"track_url"] objectAtIndex:button_number]];
    [postMutableArray.jacket_url addObject:[[items objectForKey:@"jacket_url"] objectAtIndex:button_number]];
    [postMutableArray.artists addObject:[[items objectForKey:@"artists"] objectAtIndex:button_number]];
}

- (void) removePostMutableArray:(NSInteger)button_number {
    [postMutableArray removeObject:[[selectDictionary objectForKey:[NSString stringWithFormat:@"%d", button_number]] intValue]];
    [selectDictionary removeObjectForKey:[NSString stringWithFormat:@"%d", button_number]];
}

// when any button selected.
- (void) setGridView:(NSMutableDictionary*)localItems
{
    gridView.numberOfColumns = 4;
    [gridView setItems:localItems];
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