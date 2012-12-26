//
//  DetailTableView.m
//  iTunesSearch
//
//  Created by s_akiba on 12/12/10.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "DetailTableView.h"
#import "HttpClient.h"
#import "ImageLoader.h"
#import "DetailArray.h"
#import "DetailCell.h"
#import "SBJson.h"
#import "PostToServer.h"

#define MUSIC_DELETE_URL @"http://neiro.me/api/test/deleteMusic.php"

@interface DetailTableView () {
    DetailArray *detailArray;
    ImageLoader *imageLoader;
}

@end

@implementation DetailTableView

@synthesize urlString, is_editable, pocket_id;

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setDelegate:(id)self];
        [self setDataSource:(id)self];
    }
    return self;
}

- (void) mainTableLoad {
    detailArray = [[DetailArray alloc] init];
    
    NSString *encURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:encURL]];
    
    void (^onSuccess)(NSData *) = ^(NSData *data) {
        NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSDictionary *json = [json_string JSONValue];
        for (NSDictionary* photo in json) {
            [detailArray.music_title addObject:[photo objectForKey:@"music_title"]];
            [detailArray.jacket_url addObject:[photo objectForKey:@"jacket_url"]];
            [detailArray.artists addObject:[photo objectForKey:@"artist"]];
            [detailArray.music_id addObject:[photo objectForKey:@"music_id"]];
            [detailArray.track_url addObject:[photo objectForKey:@"track_url"]];
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
    DetailCell *cell = (DetailCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell==nil) {
        cell = [[DetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    [cell.musicTitle setText:[detailArray.music_title objectAtIndex:indexPath.row]];
    [cell.artist setText:[detailArray.artists objectAtIndex:indexPath.row]];

    NSString *pathUrlImage = [detailArray.jacket_url objectAtIndex:indexPath.row];
    imageLoader = [ImageLoader sharedInstance];
    UIImage *jacketImage = [imageLoader cacedImageForUrl:pathUrlImage];
    cell.tlImageView.image = jacketImage;

    if (!jacketImage) {
        __weak DetailTableView *_self = self;
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

- (void) reloadJacketIcon:(int)integer jacktImage:(UIImage*)image {
    DetailCell *cell = (DetailCell*)[self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:integer inSection:0]];
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

//リストアイテムの数。
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [detailArray.music_title count];
}

//セクションの数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//セルを選択したとき
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [myPocketDelegate performSelector:@selector(pushToDetailView:) withObject:[tlArray.shared objectAtIndex:indexPath.row]];
//    [self deselectRowAtIndexPath:indexPath animated:YES];
}

//セルの高さ
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCellEditingStyle)tableView:(UITableView*)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (is_editable) {
        return UITableViewCellEditingStyleDelete;
    } else {
        return UITableViewCellEditingStyleNone;
    }
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:pocket_id forKey:@"pocket_id"];
        [dictionary setValue:[detailArray.music_id objectAtIndex:indexPath.row] forKey:@"music_id"];
        NSURL *url = [[NSURL alloc] initWithString:MUSIC_DELETE_URL];

        PostToServer *postToServer = [[PostToServer alloc] init];
        [postToServer postData:dictionary :url :@"deleteMusic"];

        [detailArray removeAtIndex:indexPath.row];
        [self deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // ここは空のままでOKです。
    }
    FUNC();
}


@end