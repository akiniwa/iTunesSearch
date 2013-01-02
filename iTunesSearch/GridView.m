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

#define JACKET_SIZE 77
#define LABEL_HEIGHT 15

@interface GridView ()
{
    NSMutableArray *artists;
    NSMutableArray *jacket_url;
    NSMutableArray *views;
    NSMutableArray *titles;
    NSMutableArray *track_url;
    ImageLoader *imageLoader;
}
@end

@implementation GridView

@synthesize numberOfColumns, delegateGridView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setItems:(NSMutableDictionary *)value {

    artists = [value objectForKey:@"artists"];
    track_url = [value objectForKey:@"track_url"];
    jacket_url = [value objectForKey:@"jacket_url"];
    views = [value objectForKey:@"views"];
    titles = [value objectForKey:@"titles"];

    if (value != items) {
        for (UIView *item in views) {
            // ここで、渡されたurlを受け取り、非同期でimageを取得する。
            [item removeFromSuperview];
        }
            [items release];
            items = [value copy];

        for (NSInteger i=0;i<[jacket_url count];i++) {

            UIView *view = [views objectAtIndex:i];
            NSString *jacketUrl = [jacket_url objectAtIndex:i];
            NSString *trackTitle = [titles objectAtIndex:i];

            imageLoader = [ImageLoader sharedInstance];
            UIImage *userImg = [imageLoader cacedImageForUrl:jacketUrl];
            
            CheckButton *btn = [CheckButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:userImg forState:UIControlStateNormal];
            btn.frame = CGRectMake(0, 0, JACKET_SIZE, JACKET_SIZE);
            btn.tag = i;
            btn.enabled = YES;
            btn.accessibilityElementsHidden = YES;
            [btn addTarget:self action:@selector(performBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];

            if (!userImg) {
                [imageLoader loadImage:jacketUrl completion:^(UIImage *image) {
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
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, JACKET_SIZE, 80, LABEL_HEIGHT)];
            label.text = trackTitle;
            label.font = [UIFont systemFontOfSize:9];
            [[views objectAtIndex:i] addSubview:label];
            [self addSubview:[views objectAtIndex:i]];
        }
        for (UIView *item in views) {
            [self addSubview:item];
        }
            [self setNeedsLayout];
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
    [btn setCheckButton];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSString stringWithFormat:@"%d", btn.tag] forKey:@"button_number"];
    if ([btn confirmIsChecked]) {
        [dictionary setObject:@"YES" forKey:@"is_checked"];
    } else {
        [dictionary setObject:@"NO" forKey:@"is_checked"];
    }
    [delegateGridView performSelector:@selector(notificateNumbers:) withObject:dictionary];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat width = [self frame].size.width / numberOfColumns;
    CGFloat height = width;
    CGFloat xoffset = 0;
    CGFloat yoffset = 0;

    for (UIView *item in views) {
        [item setFrame:CGRectMake(xoffset + 1, yoffset + 1, width - 2, height - 2)];
        xoffset += width;
        if (xoffset >= [self frame].size.width) {
            xoffset = 0;
            yoffset += height + LABEL_HEIGHT;
        }
    }
}

@end