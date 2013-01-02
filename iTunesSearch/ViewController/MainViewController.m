//
//  MainViewController.m
//  iTunesSearch
//
//  Created by s_akiba on 12/10/25.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "MainViewController.h"
#import "SBJson.h"
#import "HttpClient.h"
#import "PostToServer.h"
#import "PostMutableArray.h"
#import "GridViewForAddingMusicController.h"

#define PREVIEW_URL @"http://itunes.apple.com/search?media=music&country=jp&entity=album&limit=15&term="
#define RSS_FEED_JPOP @"https://itunes.apple.com/jp/rss/topsongs/limit=25/genre=27/json"
#define RSS_FEED_ROCK @"https://itunes.apple.com/jp/rss/topsongs/limit=25/genre=21/json"
#define RSS_FEED_ANIME @"https://itunes.apple.com/jp/rss/topsongs/limit=25/genre=29/json"
#define RSS_FEED_RB @"https://itunes.apple.com/jp/rss/topsongs/limit=25/genre=15/json"

#define POST_URL @"http://neiro.me/api/test/createMusic.php"

#define LIMIT 25

enum view {
    VIEW_TOP,
    VIEW_MIDDLE,
    VIEW_BOTTOM
};

@interface MainViewController ()
{
    PostMutableArray *postMutableArray;

    UILabel *postCount;
    // postMutableArrayとscreen, buttonをひも付ける。

    // selectDictionaryはpostMutableArrayの要素を消去する際に必要。
    NSMutableArray *selectDictionaryArray;
    
    UITextField *txField;
}
@end

@implementation MainViewController

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
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bar"] forBarMetrics:UIBarMetricsDefault];

    txField = [[UITextField alloc] initWithFrame:CGRectMake(20, 30, 190, 30)];
    txField.delegate = (id)self;
    txField.borderStyle = UITextBorderStyleBezel;
    [self.view addSubview:txField];

    UIButton *customView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 30)];
    [customView setBackgroundImage:[UIImage imageNamed:@"cancelBtn.png"] forState:UIControlStateNormal];
    [customView addTarget:self action:@selector(modalClose) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* buttonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    self.navigationItem.leftBarButtonItem = buttonItem;

    UIButton *barButtom = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [barButtom setFrame:CGRectMake(0, 0, 55, 30)];
    [barButtom setTitle:@"post" forState:UIControlStateNormal];
    [barButtom addTarget:self action:@selector(postToCheck) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithCustomView:barButtom];
    self.navigationItem.rightBarButtonItem = rightButton;

    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [searchButton setFrame:CGRectMake(240, 25, 80, 30)];
    [searchButton setTitle:@"search" forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchMusic) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchButton];

    postMutableArray = [[PostMutableArray alloc] init];
    selectDictionaryArray = [NSMutableArray array];

    GridViewForAddingMusicController *gridView = [[GridViewForAddingMusicController alloc] init];
    gridView.artistName = @"glay";
    gridView.gridViewDelegate = self;
    [self addChildViewController:gridView];

    [self.view addSubview:gridView.view];

    postCount = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 300, 20)];
    [postCount setText:[NSString stringWithFormat:@"%d曲が選択されています。", [postMutableArray.pocket_id count]]];
    [self.view addSubview:postCount];
}

-(void) modalClose {
    [self dismissModalViewControllerAnimated:YES];
}

- (void) setArray:(NSMutableDictionary *)dictionary {
    NSDictionary *dict = [dictionary objectForKey:@"dictionary"];
    [postMutableArray.artists addObject:[dict objectForKey:@"artist"]];
    [postMutableArray.track_url addObject:[dict objectForKey:@"track_url"]];
    [postMutableArray.titles addObject:[dict objectForKey:@"music_title"]];
    [postMutableArray.jacket_url addObject:[dict objectForKey:@"jacket_url"]];
}

- (void) postToCheck {
    NSURL *url = [[NSURL alloc] initWithString:POST_URL];
    // ここで配列をディクショナリを作り直す。
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    [dictionary setObject:postMutableArray.artists forKey:@"artists"];
    [dictionary setObject:postMutableArray.titles forKey:@"titles"];
    [dictionary setObject:postMutableArray.track_url forKey:@"track_url"];
    [dictionary setObject:postMutableArray.jacket_url forKey:@"jacket_url"];
    [dictionary setObject:pocket_id forKey:@"pocket_id"];

    PostToServer *postToServer = [[PostToServer alloc] init];

    [postToServer postData:dictionary :url :@"post_to_music"];
}

- (void) searchMusic {
    if (!txField.text) {

    } else {
    }
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField {
    [txField resignFirstResponder];
    return YES;
}

- (void) notificateNumbers:(NSMutableDictionary*)dictionary {
    NSInteger grid_number = [[dictionary objectForKey:@"grid_number"] intValue];
    BOOL is_checked = [(NSNumber*)[dictionary objectForKey:@"is_checked"] boolValue];
    if (is_checked) {
        [selectDictionaryArray addObject:[dictionary objectForKey:@"grid_number"]];
        [self setArray:dictionary];
    } else {
        [self removePostMutableArray:grid_number];
    }
    [self setPostCount];
}

- (void) setPostCount {
    [postCount setText:[NSString stringWithFormat:@"%d曲が選択されています。", [postMutableArray.artists count]]];
}

- (void) removePostMutableArray:(NSInteger)grid_number {
    NSUInteger index = [selectDictionaryArray indexOfObject:[NSString stringWithFormat:@"%d", grid_number]];
    [postMutableArray removeObject:index];
    [selectDictionaryArray removeObjectAtIndex:index];
}

@end