//
//  MyPocketTableView.m
//  iTunesSearch
//
//  Created by s_akiba on 12/12/06.
//  Copyright (c) 2012年 s_akiba. All rights reserved.

#import "MyPocketTableView.h"
#import "TLArray.h"
#import "TLCell.h"
#import "ImageLoader.h"
#import "SBJson.h"
#import "HttpClient.h"
#import "PostToServer.h"

#define POCKET_SHARE_URL @"http://neiro.me/api/test/sharePocket.php"
#define POCKET_DELETE_URL @"http://neiro.me/api/test/deletePocket.php"

static NSString *user_id;

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
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        user_id = [defaults objectForKey:@"user_id"];
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

- (int) checkPocketId:(NSMutableArray*)array {
    if ([array count]) {
        return [[array objectAtIndex:0] intValue];
    } else {
        return 0;
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
            if ([[value objectForKey:@"pocket_id"] intValue] > [self checkPocketId:tlArray.pocket_id]) {
                n++;
            }
            [tlReloadArray.user_name addObject:[value objectForKey:@"user_name"]];
            [tlReloadArray.shared addObject:[value objectForKey:@"shared"]];
            [tlReloadArray.pocket_title addObject:[value objectForKey:@"pocket_title"]];
            [tlReloadArray.music_title addObject:[value objectForKey:@"music_title"]];
            [tlReloadArray.jacket_url addObject:[value objectForKey:@"jacket_url"]];
            [tlReloadArray.pocket_id addObject:[value objectForKey:@"pocket_id"]];
            [tlReloadArray.user_id addObject:[value objectForKey:@"user_id"]];
            [tlReloadArray.music_count addObject:[value objectForKey:@"music_count"]];
        }

        int k = n;
        for (int l=0; l<[tlReloadArray.user_id count]; l++) {
            if (l<k) {
                [self insertObjectToTLArray:tlArray.user_name :tlReloadArray.user_name :n];
                [self insertObjectToTLArray:tlArray.shared :tlReloadArray.shared :n];
                [self insertObjectToTLArray:tlArray.pocket_title :tlReloadArray.pocket_title :n];
                [self insertObjectToTLArray:tlArray.music_title :tlReloadArray.music_title :n];
                [self insertObjectToTLArray:tlArray.jacket_url :tlReloadArray.jacket_url :n];
                [self insertObjectToTLArray:tlArray.pocket_id :tlReloadArray.pocket_id :n];
                [self insertObjectToTLArray:tlArray.user_id :tlReloadArray.user_id :n];
                [self insertObjectToTLArray:tlArray.music_count :tlReloadArray.music_count :n];
                n--;
                DEBUGLOG(@"insert");
            } else {
                [self replaceObjectToTLArray:tlArray.user_name :tlReloadArray.user_name :l];
                [self replaceObjectToTLArray:tlArray.shared :tlReloadArray.shared :l];
                [self replaceObjectToTLArray:tlArray.pocket_title :tlReloadArray.pocket_title :l];
                [self replaceObjectToTLArray:tlArray.music_title :tlReloadArray.music_title :l];
                [self replaceObjectToTLArray:tlArray.jacket_url :tlReloadArray.jacket_url :l];
                [self replaceObjectToTLArray:tlArray.pocket_id :tlReloadArray.pocket_id :l];
                [self replaceObjectToTLArray:tlArray.user_id :tlReloadArray.user_id :l];
                [self replaceObjectToTLArray:tlArray.music_count :tlReloadArray.music_count :l];
                DEBUGLOG(@"replace");
            }
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

- (void) insertObjectToTLArray:(NSMutableArray*)tableArray:(NSMutableArray*)tlReloadArray:(int)indexNumber {
    [tableArray insertObject:[tlReloadArray objectAtIndex:indexNumber-1] atIndex:0];
}

- (void) replaceObjectToTLArray:(NSMutableArray*)tableArray:(NSMutableArray*)tlReloadArray:(int)indexNumber {
    [tableArray replaceObjectAtIndex:indexNumber withObject:[tlReloadArray objectAtIndex:indexNumber]];
}

- (NSURLRequest*) getRequest {
    NSString *encURL = [[NSString stringWithFormat:@"%@%@%@", urlString, @"?user_id=", user_id] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

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
    cell.tlImageView.alpha = 0.0f;
    cell.tlImageView.image = jacketImage;
    


    if (![[tlArray.user_id objectAtIndex:indexPath.row] isEqualToString:user_id]) {
        [cell setButton];
        cell.shareButton.tag = indexPath.row;
        [cell.shareButton addTarget:self action:@selector(sharePocket:) forControlEvents:UIControlEventTouchUpInside];
    } else {
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
    } else {
        [self cellAnimation:cell];
    }

    return cell;
}

- (void) cellAnimation:(TLCell*)cell {
    [cell setNeedsLayout];
    [cell setNeedsDisplay];
    [UIView animateWithDuration:1.2f
                     animations:^{
                         cell.tlImageView.alpha = 1.0f;
                     }completion:^(BOOL finised){
                         
                     }];
}

- (void) sharePocket:(id)sender {
    UIButton *shareButton = (UIButton*)sender;

    NSString *pocket_id = [tlArray.pocket_id objectAtIndex:shareButton.tag];

    DEBUGLOG(@":%d:%d", [user_id intValue], [pocket_id intValue]);

    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:user_id forKey:@"user_id"];
    [dictionary setValue:pocket_id forKey:@"pocket_id"];
    NSURL *url = [[NSURL alloc] initWithString:POCKET_SHARE_URL];

    PostToServer *postToServer = [[PostToServer alloc] init];
    [postToServer postData:dictionary :url :@"sharePocket"];
}

- (void) reloadJacketIcon:(int)integer jacktImage:(UIImage*)image {
    TLCell *cell = (TLCell*)[self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:integer inSection:0]];
    cell.tlImageView.image = image;
    [self cellAnimation:cell];
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
    ;
    NSString *is_mine;
    if ([[tlArray.user_id objectAtIndex:indexPath.row] isEqualToString:user_id]) {
        is_mine = @"YES";
    } else {
        is_mine = @"NO";
    }
    NSString *pocket_id = [tlArray.pocket_id objectAtIndex:indexPath.row];
    [myPocketDelegate performSelector:@selector(pushToDetailView::) withObject:pocket_id withObject:is_mine];
    
    [self deselectRowAtIndexPath:indexPath animated:YES];
}

// セルの高さ
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect r = self.bounds;
    if ((r.origin.y < -70) && (headerOn == NO)) {
		headerOn = YES;
	}
	if ((r.origin.y > -70) && (headerOn == YES)) {
		headerOn = NO;
    }
    [myPocketDelegate performSelector:@selector(hideMusicView)];
}

- (void) endScroll{
    [myPocketDelegate performSelector:@selector(showMusicView)];
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

- (UITableViewCellEditingStyle)tableView:(UITableView*)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([user_id isEqualToString:[tlArray.user_id objectAtIndex:indexPath.row]]) {
        return UITableViewCellEditingStyleDelete;
    } else {
        return UITableViewCellEditingStyleNone;
    }
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:[tlArray.pocket_id objectAtIndex:indexPath.row] forKey:@"pocket_id"];

        NSURL *url = [[NSURL alloc] initWithString:POCKET_DELETE_URL];
        
        PostToServer *postToServer = [[PostToServer alloc] init];
        [postToServer postData:dictionary :url :@"deletePocket"];

        [tlArray removeAtIndexPath:indexPath.row];
        
        [self deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // ここは空のままでOKです。
    }
    FUNC();
}

@end