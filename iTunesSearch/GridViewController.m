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

#define NUMBER_OF_COLUMNS 4

#define PREVIEW_URL @"http://itunes.apple.com/search?media=music&country=jp&entity=song&limit=24&term="
#define POPULAR_URL @"http://neiro.me/api/test/createJson.php"

@interface GridViewController ()

@end

@implementation GridViewController

@synthesize artistName, gridViewDelegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 95, bounds.size.width, bounds.size.height)];

    postMutableArray = [[PostMutableArray alloc] init];

    gridView = [[GridView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height)];
    gridView.backgroundColor = [UIColor clearColor];
    gridView.delegateGridView = self;

    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height - 60)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.contentSize = CGSizeMake(bounds.size.width, bounds.size.height + 120);
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];

    [scrollView addSubview:gridView];
    [self makeMutableArray];
}

- (void) makeMutableArray {
    NSString *strURL;
    if ([artistName isEqualToString:@""]) {
        strURL = POPULAR_URL;
    } else {
        strURL = [NSString stringWithFormat:@"%@%@",PREVIEW_URL, artistName];
    }

    NSString *encURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:encURL]];

    void (^onSuccess)(NSData *) = ^(NSData *data) {
        NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

        NSDictionary *statuses = [json_string JSONValue];

        NSMutableArray *info = [statuses objectForKey:@"results"];

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
        scrollView.contentSize = CGSizeMake(320, (height + 95));
        gridView.frame = CGRectMake(0, 0, 320, height);
 
        [self performSelectorOnMainThread:@selector(setGridView:) withObject:items waitUntilDone:YES];
    };
    void (^onError)(NSError *) = ^(NSError *error) {
        
    };
    @try {
        [HttpClient request:request success:onSuccess error:onError];
    }
    @catch (NSException *exception) {
    }
}

- (void) notificateNumbers:(NSMutableDictionary *)dictionary {
}

- (void) setGridView:(NSMutableDictionary*)localItems
{
    gridView.numberOfColumns = NUMBER_OF_COLUMNS;
    [gridView setItems:localItems];
}

- (void)setImage{
    [gridView setNeedsDisplay];
    [gridView setNeedsLayout];
}

@end