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
}
@end

@implementation MyPocketTableView

@synthesize urlString, myPocketDelegate;

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
    
    NSString *encURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:encURL]];
    
    void (^onSuccess)(NSData *) = ^(NSData *data) {
        NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSDictionary *json = [json_string JSONValue];
        for (NSDictionary* photo in json) {
            [tlArray.user_name addObject:[photo objectForKey:@"user_name"]];
            [tlArray.shared addObject:[photo objectForKey:@"shared"]];
            [tlArray.pocket_title addObject:[photo objectForKey:@"pocket_title"]];
            [tlArray.music_title addObject:[photo objectForKey:@"music_title"]];
            [tlArray.jacket_url addObject:[photo objectForKey:@"jacket_url"]];
            [tlArray.pocket_id addObject:[photo objectForKey:@"pocket_id"]];
            [tlArray.user_id addObject:[photo objectForKey:@"user_id"]];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    TLCell *cell = (TLCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell==nil) {
        cell = [[TLCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    [cell.shared setText:[tlArray.shared objectAtIndex:indexPath.row]];
    [cell.pocketTitle setText:[tlArray.pocket_title objectAtIndex:indexPath.row]];
    [cell.userName setText:[tlArray.user_name objectAtIndex:indexPath.row]];
    [cell.musicTitle setText:[tlArray.music_title objectAtIndex:indexPath.row]];

    NSString *pathUrlImage = [tlArray.jacket_url objectAtIndex:indexPath.row];
    imageLoader = [ImageLoader sharedInstance];
    UIImage *jacketImage = [imageLoader cacedImageForUrl:pathUrlImage];
    cell.tlImageView.image = jacketImage;

    if (is_button) {
        [cell setButton];
        cell.shareButton.tag = indexPath.row;
        [cell.shareButton addTarget:self action:@selector(sharePocket:) forControlEvents:UIControlEventTouchUpInside];
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
    NSString *user_id = [tlArray.user_id objectAtIndex:shareButton.tag];
    NSString *pocket_id = [tlArray.pocket_id objectAtIndex:shareButton.tag];

    DEBUGLOG(@":%d:%d", [user_id intValue], [pocket_id intValue]);

    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:user_id forKey:@"user_id"];
    [dictionary setValue:pocket_id forKey:@"pocket_id"];
    NSURL *url = [[NSURL alloc] initWithString:POCKET_URL];
    
    [PostToServer postData:dictionary :url :@"pocket"];
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
    [myPocketDelegate performSelector:@selector(pushToDetailView:) withObject:[tlArray.pocket_id objectAtIndex:indexPath.row]];
    [self deselectRowAtIndexPath:indexPath animated:YES];
}

// セルの高さ
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190;
}

@end