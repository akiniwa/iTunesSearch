//
//  GridView.m
//
//  GridViewはそれぞれのグリッドごとにviewと値をもつことができ、
//  画像のurlを指定することで、viewに画像を非同期で表示することができる。
//  また、delegateGridViewに渡されたidに対して、checkedとunchecked、
//  と対応する要素の番号を通知する。
//
//  Created by s_akiba on 12/10/25.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "GridView.h"
#import "GridArray.h"
#import "ImageLoader.h"
#import "CheckButton.h"

#define JACKET_SIZE 77
#define LABEL_HEIGHT 15

@interface GridView ()
{
    GridArray *gridArray;
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

    gridArray = [[GridArray alloc] init];

    
    gridArray.artists = [value objectForKey:@"artists"];
    gridArray.track_url = [value objectForKey:@"track_url"];
    gridArray.jacket_url = [value objectForKey:@"jacket_url"];
    gridArray.views = [value objectForKey:@"views"];
    gridArray.music_title = [value objectForKey:@"titles"];

    if (value != items) {
        for (UIView *item in gridArray.views) {
            // ここで、渡されたurlを受け取り、非同期でimageを取得する。
            [item removeFromSuperview];
        }
            [items release];
            items = [value copy];

        for (NSInteger i=0;i<[gridArray.jacket_url count];i++) {

            UIView *view = [gridArray.views objectAtIndex:i];
            NSString *jacketUrl = [gridArray.jacket_url objectAtIndex:i];
            NSString *musicTitle = [gridArray.music_title objectAtIndex:i];

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
            label.text = musicTitle;
            label.font = [UIFont systemFontOfSize:9];
            [[gridArray.views objectAtIndex:i] addSubview:label];
            [self addSubview:[gridArray.views objectAtIndex:i]];
        }
        for (UIView *item in gridArray.views) {
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
    [dictionary setObject:[NSString stringWithFormat:@"%d", btn.tag] forKey:@"grid_number"];
    [dictionary setObject:[gridArray dictionaryAtindex:btn.tag] forKey:@"dictionary"];
    if ([btn confirmIsChecked]) {
        [dictionary setObject:[NSNumber numberWithBool:YES] forKey:@"is_checked"];
    } else {
        [dictionary setObject:[NSNumber numberWithBool:NO] forKey:@"is_checked"];
    }
    [delegateGridView performSelector:@selector(notificateNumbers:) withObject:dictionary];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat width = [self frame].size.width / numberOfColumns;
    CGFloat height = width;
    CGFloat xoffset = 0;
    CGFloat yoffset = 0;

    for (UIView *item in gridArray.views) {
        [item setFrame:CGRectMake(xoffset + 1, yoffset + 1, width - 2, height - 2)];
        xoffset += width;
        if (xoffset >= [self frame].size.width) {
            xoffset = 0;
            yoffset += height + LABEL_HEIGHT;
        }
    }
}

@end