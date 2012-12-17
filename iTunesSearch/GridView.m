//
//  GridView.m
//  iTunesSearch
//
//  Created by s_akiba on 12/10/25.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "GridView.h"
#import "ImageLoader.h"
#import "CheckButton.h"

@interface GridView ()
{
    NSMutableArray *artists;
    NSMutableArray *artworks;
    NSMutableArray *views;
    NSMutableArray *tracks;
    ImageLoader *imageLoader;
}
@end

@implementation GridView

@synthesize numberOfColumns;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setItems:(NSMutableDictionary *)value {

    artists = [value objectForKey:@"artists"];
    artworks = [value objectForKey:@"artworks"];
    views = [value objectForKey:@"views"];
    tracks = [value objectForKey:@"tracks"];

    if (value != items) {
        for (UIView *item in views) {
            // ここで、渡されたurlを受け取り、非同期でimageを取得する。
            [item removeFromSuperview];
        }
            [items release];
            items = [value copy];

        for (NSInteger i=0;i<[artworks count];i++) {

            UIView *view = [views objectAtIndex:i];
            NSString *artworkURL = [artworks objectAtIndex:i];
            NSString *albumName = [tracks objectAtIndex:i];

            imageLoader = [ImageLoader sharedInstance];
            UIImage *userImg = [imageLoader cacedImageForUrl:[artworks objectAtIndex:i]];
            
            CheckButton *btn = [CheckButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:userImg forState:UIControlStateNormal];
            btn.frame = CGRectMake(0, 0, 77, 77);
            btn.tag = i;
            btn.enabled = YES;
            btn.accessibilityElementsHidden = YES;
            [btn addTarget:self action:@selector(performBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];

            if (!userImg) {
                [imageLoader loadImage:artworkURL completion:^(UIImage *image) {
                    SEL selector = @selector(setImages:btn:);
                    // シグネチャを作成
                    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:selector];
                    // invocationの作成
                    CheckButton *localBtn = btn;
                    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
                    [invocation setTarget:self];
                    [invocation setArgument:&image atIndex:2];
                    [invocation setArgument:&localBtn atIndex:3];
                    [invocation setSelector:selector];
                    [self performSelectorOnMainThread:@selector(performArtWorkIcon:) withObject:invocation waitUntilDone:YES];
                    }];
            }

            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, 80, 15)];
            label.text = albumName;
            label.font = [UIFont systemFontOfSize:9];
            [[views objectAtIndex:i] addSubview:label];
            [self addSubview:[views objectAtIndex:i]];
        }
        for (UIView *item in views) {
            [self addSubview:item];
        }
            [self setNeedsLayout];
        //  just in case.
    }

}

-(void)performArtWorkIcon:(NSInvocation*)anInvocation
{
	[anInvocation invokeWithTarget:self];
}

- (void) setImages:(UIImage*)image btn:(CheckButton*)btn
{
    [btn setImage:image forState:UIControlStateNormal];
    [self setNeedsDisplay];
    [self setNeedsLayout];
}

-(void)performBtnEvent:(CheckButton*)btn
{
    NSString *artist = [artists objectAtIndex:btn.tag];
    NSString *track = [tracks objectAtIndex:btn.tag];

    [btn setCheckButton];
    
    [self touchEvent:artist :track];
}

- (void) touchEvent:(NSString*)artist:(NSString*)artwork {
/*
    UIAlertView *alert =
    [[UIAlertView alloc]
     initWithTitle:artist
     message:artwork
     delegate:nil
     cancelButtonTitle:nil
     otherButtonTitles:@"OK", nil
     ];
    [alert show];
    DEBUGLOG(@"artist:%@",artist);
    DEBUGLOG(@"artwork:%@", artwork);
 */
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    LINE();
    CGFloat width = [self frame].size.width / numberOfColumns;
    CGFloat height = width;
    CGFloat xoffset = 0;
    CGFloat yoffset = 0;

    for (UIView *item in views) {
        [item setFrame:CGRectMake(xoffset + 1, yoffset + 1, width - 2, height - 2)];
        xoffset += width;
        if (xoffset >= [self frame].size.width) {
            xoffset = 0;
            yoffset += height;
        }
    }
}

@end