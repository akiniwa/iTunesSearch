//
//  MyPocketTableView.m
//  iTunesSearch
//
//  Created by s_akiba on 12/12/06.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "MyPocketTableView.h"
#import "TLArray.h"
#import "TLCell.h"
#import "ImageLoader.h"
#import "SBJson.h"
#import "HttpClient.h"
#import "PostToServer.h"

#define POCKET_URL @"http://neiro.me/api/share.php"

@interface MyPocketTableView () {
    TLArray *tlArray;
    ImageLoader *imageLoader;
    BOOL headerOn;
}
@end

@implementation MyPocketTableView

@synthesize urlString, myPocketDelegate, is_button;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setDelegate:(id)self];
        [self setDataSource:(id)self];
    }
    return self;
}

- (void) mainTableLoad {
    tlArray = [[TLArray alloc] init];
    
    NSURLRequest *request = [self getRequest];
    
    void (^onSuccess)(NSData *) = ^(NSData *data) {
        NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

        NSDictionary *json = [json_string JSONValue];

        for (NSDictionary* value in json) {
            [tlArray.user_name addObject:[value objectForKey:@"user_name"]];
            [tlArray.shared addObject:[value objectForKey:@"shared"]];
            [tlArray.pocket_title addObject:[value objectForKey:@"pocket_title"]];
            [tlArray.music_title addObject:[value objectForKey:@"music_title"]];
            [tlArray.jacket_url addObject:[value objectForKey:@"jacket_url"]];
            [tlArray.pocket_id addObject:[value objectForKey:@"pocket_id"]];
            [tlArray.user_id addObject:[value objectForKey:@"user_id"]];
            [tlArray.music_count addObject:[value objectForKey:@"music_count"]];
        }
        [self performSelectorOnMainThread:@selector(updatePlayState) withObject:nil waitUntilDone:YES];
    };
    void (^onError)(NSError *) = ^(NSError *error) {
    };
    
    @try {
        [HttpClient request:request success:onSuccess error:onError];
    }
    @catch (NSException *exception) {
    }
}

- (void) reloadTable {
    FUNC();
    // 追加用の配列
    TLArray *tlReloadArray = [[TLArray alloc] init];
    
    NSURLRequest *request = [self getRequest];
    
    void (^onSuccess)(NSData *) = ^(NSData *data) {
        NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSDictionary *json = [json_string JSONValue];
        
        int n = 0;
        
        for (NSDictionary *value in json) {
            if ([[value objectForKey:@"pocket_id"] intValue]>[[tlArray.pocket_id objectAtIndex:0] intValue]) {
                
                [tlReloadArray.user_name addObject:[value objectForKey:@"user_name"]];
                [tlReloadArray.shared addObject:[value objectForKey:@"shared"]];
                [tlReloadArray.pocket_title addObject:[value objectForKey:@"pocket_title"]];
                [tlReloadArray.music_title addObject:[value objectForKey:@"music_title"]];
                [tlReloadArray.jacket_url addObject:[value objectForKey:@"jacket_url"]];
                [tlReloadArray.pocket_id addObject:[value objectForKey:@"pocket_id"]];
                [tlReloadArray.user_id addObject:[value objectForKey:@"user_id"]];
                [tlReloadArray.music_count addObject:[value objectForKey:@"music_count"]];
                n++;
            } else {
                break;
            }
        }
        int k = n;
        for (int l=0; l<k; l++) {
            [self insertObjectToTLArray:tlArray.user_name :tlReloadArray.user_name :n];
            [self insertObjectToTLArray:tlArray.shared :tlReloadArray.shared :n];
            [self insertObjectToTLArray:tlArray.pocket_title :tlReloadArray.pocket_title :n];
            [self insertObjectToTLArray:tlArray.music_title :tlReloadArray.music_title :n];
            [self insertObjectToTLArray:tlArray.jacket_url :tlReloadArray.jacket_url :n];
            [self insertObjectToTLArray:tlArray.pocket_id :tlReloadArray.pocket_id :n];
            [self insertObjectToTLArray:tlArray.user_id :tlReloadArray.user_id :n];
            [self insertObjectToTLArray:tlArray.music_count :tlReloadArray.music_count :n];
            n--;
        }
        [self performSelectorOnMainThread:@selector(updatePlayState) withObject:nil waitUntilDone:YES];
    };
    void (^onError)(NSError *) = ^(NSError *error) {
    };
    
    @try {
        [HttpClient request:request success:onSuccess error:onError];
    }
    @catch (NSException *exception) {
    }

}

- (void) insertObjectToTLArray:(NSMutableArray*)tableArray:(NSMutableArray*)tlReloadArray:(int)n {
    DEBUGLOG(@"tlReloadArray:%@", [tlReloadArray objectAtIndex:n-1]);
    [tableArray insertObject:[tlReloadArray objectAtIndex:n-1] atIndex:0];
}

- (NSURLRequest*) getRequest {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *encURL = [[NSString stringWithFormat:@"%@%@%@", urlString, @"?user_id=",[defaults objectForKey:@"user_id"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:encURL]];
    return request;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    TLCell *cell = (TLCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell==nil) {
        cell = [[TLCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    [cell.pocketTitle setText:[tlArray.pocket_title objectAtIndex:indexPath.row]];
    [cell.userName setText:[tlArray.user_name objectAtIndex:indexPath.row]];
    [cell.musicCount setText:[tlArray.music_count objectAtIndex:indexPath.row]];

    NSString *pathUrlImage;

    if ([[tlArray.music_count objectAtIndex:indexPath.row] intValue]) {
        [cell.shared setText:[tlArray.shared objectAtIndex:indexPath.row]];
        [cell.musicTitle setText:[tlArray.music_title objectAtIndex:indexPath.row]];

        pathUrlImage = [tlArray.jacket_url objectAtIndex:indexPath.row];
        
    } else {
        [cell.shared setText:@"0"];
        [cell.musicTitle setText:@"曲が未登録です。"];
        pathUrlImage = @"http://neiro.me/api/test/empty.jpg";
    }

    imageLoader = [ImageLoader sharedInstance];
    UIImage *jacketImage = [imageLoader cacedImageForUrl:pathUrlImage];
    cell.tlImageView.image = jacketImage;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* user_id = [defaults objectForKey:@"user_id"];

    if (![[tlArray.user_id objectAtIndex:indexPath.row] isEqualToString:user_id]) {
        [cell setButton];
        cell.shareButton.tag = indexPath.row;
        [cell.shareButton addTarget:self action:@selector(sharePocket:) forControlEvents:UIControlEventTouchUpInside];
    } else {
//        [cell.shareButton removeFromSuperview];
        [cell removeButton];
    }

    if (!jacketImage) {
        __weak MyPocketTableView *_self = self;
        [imageLoader loadImage:pathUrlImage completion:^(UIImage *image) {
            SEL selector = @selector(reloadJacketIcon:jacktImage:);
            int cellNumber = indexPath.row;

            NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:selector];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:self];
            [invocation setArgument:&cellNumber atIndex:2];
            [invocation setArgument:&image atIndex:3];
            [invocation setSelector:selector];
            [_self performSelectorOnMainThread:@selector(performJacketIcon:) withObject:invocation waitUntilDone:YES];
        }];
    }
    return cell;
}

- (void) sharePocket:(id)sender {
    UIButton *shareButton = (UIButton*)sender;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSString *user_id = [defaults objectForKey:@"user_id"];
    NSString *pocket_id = [tlArray.pocket_id objectAtIndex:shareButton.tag];

    DEBUGLOG(@":%d:%d", [user_id intValue], [pocket_id intValue]);

    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:user_id forKey:@"user_id"];
    [dictionary setValue:pocket_id forKey:@"pocket_id"];
    NSURL *url = [[NSURL alloc] initWithString:POCKET_URL];

    PostToServer *postToServer = [[PostToServer alloc] init];
    [postToServer postData:dictionary :url :@"share"];
}

- (void) reloadJacketIcon:(int)integer jacktImage:(UIImage*)image {
    TLCell *cell = (TLCell*)[self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:integer inSection:0]];
    cell.tlImageView.image = image;
    [cell setNeedsDisplay];
    [cell setNeedsLayout];
}

- (void) performJacketIcon:(NSInvocation*)anInvocation {
    [anInvocation invokeWithTarget:self];
}

- (void)updatePlayState {
    NSLog(@"updatePlayState");
    [self reloadData];
}

- (void)setButton {
    is_button = YES;
}

// リストアイテムの数。
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tlArray.shared count];
}

// セクションの数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// セルを選択したとき
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *button_string;
    if (is_button) {
        button_string = @"YES";
    } else {
        button_string = @"NO";
    }
    NSString *pocket_id = [tlArray.pocket_id objectAtIndex:indexPath.row];
    [myPocketDelegate performSelector:@selector(pushToDetailView::) withObject:pocket_id withObject:button_string];
    [self deselectRowAtIndexPath:indexPath animated:YES];
}

// セルの高さ
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect r = self.bounds;
    if ((r.origin.y < -70) && (headerOn == NO)) {
		headerOn = YES;
	}
	if ((r.origin.y > -70) && (headerOn == YES)) {
		headerOn = NO;
    }
//    [myPocketDelegate performSelector:@selector(hideMusicView)];
}

- (void) endScroll{
//    [myPocketDelegate performSelector:@selector(showMusicView)];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self endScroll];
}
// ドラッグ終了 かつ 加速無し
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(!decelerate) {
        [self endScroll];
    }
}
// setContentOffset: 等によるスクロール終了
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self endScroll];
}

@end