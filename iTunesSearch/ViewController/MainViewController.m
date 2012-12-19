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
#import "MovingScrollView.h"
#import "ScrollView.h"
#import "PostToServer.h"
#import "PostMutableArray.h"
#import "GridViewController.h"

#define PREVIEW_URL @"http://itunes.apple.com/search?media=music&country=jp&entity=album&limit=15&term="
#define RSS_FEED_JPOP @"https://itunes.apple.com/jp/rss/topsongs/limit=25/genre=27/json"
#define RSS_FEED_ROCK @"https://itunes.apple.com/jp/rss/topsongs/limit=25/genre=21/json"
#define RSS_FEED_ANIME @"https://itunes.apple.com/jp/rss/topsongs/limit=25/genre=29/json"
#define RSS_FEED_RB @"https://itunes.apple.com/jp/rss/topsongs/limit=25/genre=15/json"

#define POST_URL @"http://neiro.me/api/check.php"

#define LIMIT 25

enum view {
    VIEW_TOP,
    VIEW_MIDDLE,
    VIEW_BOTTOM
};

@interface MainViewController ()
{
    ScrollView *scrollView01;
    ScrollView *scrollView02;
    ScrollView *scrollView03;
    MovingScrollView *mscroll;

    PostMutableArray *postMutableArray;
    // postMutableArrayとscreen, buttonをひも付ける。
    NSMutableDictionary *selectDictionary;
    
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

    txField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, 190, 30)];
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
    [searchButton setFrame:CGRectMake(240, 5, 80, 30)];
    [searchButton setTitle:@"search" forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchMusic) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchButton];

    postMutableArray = [[PostMutableArray alloc] init];
    selectDictionary = [NSMutableDictionary dictionary];

    scrollView01 = [[ScrollView alloc] initWithFrame:CGRectMake(10, 80, 300, 100)];
    scrollView01.backgroundColor = [UIColor clearColor];
    scrollView01.flag = VIEW_TOP;
    scrollView01.scrollViewDelegate = self;
    [self.view addSubview:scrollView01];

    scrollView02 = [[ScrollView alloc] initWithFrame:CGRectMake(10, 180, 300, 100)];
    scrollView02.backgroundColor = [UIColor clearColor];
    scrollView02.flag = VIEW_MIDDLE;
    scrollView02.scrollViewDelegate = self;
    [self.view addSubview:scrollView02];

    scrollView03 = [[ScrollView alloc] initWithFrame:CGRectMake(10, 290, 300, 100)];
    scrollView03.backgroundColor = [UIColor clearColor];
    scrollView03.flag = VIEW_BOTTOM;
    scrollView03.scrollViewDelegate = self;
    [self.view addSubview:scrollView03];

//  配列を作る。
    [self makeMutableArray:RSS_FEED_ROCK :scrollView01];
    [self makeMutableArray:RSS_FEED_JPOP :scrollView02];
    [self makeMutableArray:RSS_FEED_RB :scrollView03];
}

-(void) modalClose {
    [self dismissModalViewControllerAnimated:YES];
}

- (void) makeMutableArray:(NSString*)keyword:(ScrollView*)scrollView {
    // ここでiTunesから楽曲でーたのjsonを取得する。
    // 与えられたpreviewURLやタイトルなどを送る(NSDictionary?)
    // itunesからstatusesをダウンロードするためのURLリクエストを準備
    NSString *encURL = [keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:encURL]];

    void (^onSuccess)(NSData *) = ^(NSData *data) {
        [self getJson:data :scrollView];
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

- (void) setArray:(NSMutableDictionary *)dictionary {
    for (int i=0; i<[[dictionary objectForKey:@"artists"] count]; i++) {
        NSLog(@"dd:%@", [[dictionary objectForKey:@"artists"] objectAtIndex:i]);
        [postMutableArray.artists addObject:[[dictionary objectForKey:@"artists"] objectAtIndex:i]];
        [postMutableArray.track_url addObject:[[dictionary objectForKey:@"track_url"] objectAtIndex:i]];
        [postMutableArray.titles addObject:[[dictionary objectForKey:@"titles"] objectAtIndex:i]];
        [postMutableArray.jacket_url addObject:[[dictionary objectForKey:@"jacket_url"] objectAtIndex:i]];
    }
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

    [PostToServer postData:dictionary :url :@"post_to_music"];
}

- (void) searchMusic {
    if (!txField.text) {
        
    } else {
        GridViewController *gridViewController = [[GridViewController alloc] init];
        gridViewController.artistName = txField.text;
        gridViewController.gridViewDelegate = self;

//        [self.navigationController pushViewController:gridViewController animated:YES];
        
        [self presentViewController:gridViewController animated:YES completion:nil];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField {
    [txField resignFirstResponder];
    return YES;
}

- (void) getJson:(NSData*)data:(ScrollView*)scrollView {
    NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    NSDictionary *json = [json_string JSONValue];

    NSDictionary *feed = [json objectForKey:@"feed"];
    NSMutableArray *entry = [feed objectForKey:@"entry"];

    scrollView.items = [NSMutableDictionary dictionary];

    NSMutableArray *jacket_url = [NSMutableArray array];
    NSMutableArray *artists = [NSMutableArray array];
    NSMutableArray *titles = [NSMutableArray array];
    NSMutableArray *track_url = [NSMutableArray array];

    for (NSDictionary *status in entry) {
        [artists addObject:[[status objectForKey:@"im:artist"] objectForKey:@"label"]];
        [titles addObject:[[status objectForKey:@"im:name"] objectForKey:@"label"]];
        [jacket_url addObject:[[[status objectForKey:@"im:image"] objectAtIndex:2] objectForKey:@"label"]];
        [track_url addObject:[[[[status objectForKey:@"link"] objectAtIndex:1] objectForKey:@"attributes"] objectForKey:@"href"]];
    }

    [scrollView.items setObject:jacket_url forKey:@"jacket_url"];
    [scrollView.items setObject:artists forKey:@"artists"];
    [scrollView.items setObject:titles forKey:@"titles"];
    [scrollView.items setObject:track_url forKey:@"track_url"];

    [self performSelectorOnMainThread:@selector(setScrollView:) withObject:scrollView waitUntilDone:YES];
}

- (void) notificateNumbers:(NSMutableDictionary*)dictionary {
    NSInteger button_number = [[dictionary objectForKey:@"button_number"] intValue];
    NSString *is_checked = [dictionary objectForKey:@"is_checked"];

    if ([is_checked isEqualToString:@"NO"]) {
        [self removePostMutableArray:button_number];
    } else {
        switch (button_number / LIMIT) {
            case VIEW_TOP:
                [selectDictionary setObject:[NSString stringWithFormat:@"%d", [postMutableArray.titles count]] forKey:[NSString stringWithFormat:@"%d", button_number]];
                [self addPostMutableArray:scrollView01 :button_number];
                break;
            case VIEW_MIDDLE:
                [selectDictionary setObject:[NSString stringWithFormat:@"%d", [postMutableArray.titles count]] forKey:[NSString stringWithFormat:@"%d", button_number]];
                [self addPostMutableArray:scrollView02 :button_number % LIMIT];
                break;
            case VIEW_BOTTOM:
                [selectDictionary setObject:[NSString stringWithFormat:@"%d", [postMutableArray.titles count]] forKey:[NSString stringWithFormat:@"%d", button_number]];
                [self addPostMutableArray:scrollView03 :button_number % LIMIT];
                break;
            default:
                break;
        }
    }
}

- (void) addPostMutableArray:(ScrollView*)scrollView:(NSInteger)button_number {
    [postMutableArray.titles addObject:[[scrollView.items objectForKey:@"titles"] objectAtIndex:button_number]];
    [postMutableArray.track_url addObject:[[scrollView.items objectForKey:@"track_url"] objectAtIndex:button_number]];
    [postMutableArray.jacket_url addObject:[[scrollView.items objectForKey:@"jacket_url"] objectAtIndex:button_number]];
    [postMutableArray.artists addObject:[[scrollView.items objectForKey:@"artists"] objectAtIndex:button_number]];
}

- (void) removePostMutableArray:(NSInteger)button_number {
    [postMutableArray removeObject:[[selectDictionary objectForKey:[NSString stringWithFormat:@"%d", button_number]] intValue]];
    [selectDictionary removeObjectForKey:[NSString stringWithFormat:@"%d", button_number]];
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
}

- (void) setScrollView:(ScrollView*)scrollView
{
    [scrollView setItems];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end