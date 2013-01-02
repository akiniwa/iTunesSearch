//
//  ScrollView.m
//  iTunesSearch
//
//  Created by s_akiba on 12/11/14.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "ScrollView.h"
#import "ImageLoader.h"
#import "CheckButton.h"

#define IMAGE_WIDTH			80
#define IMAGE_HEIGHT		80
#define DISPLAY_VIEW_NUM	23
#define MAX_VIEW_NUM		(DISPLAY_VIEW_NUM+2)
#define MAX_SCROLLABLE_IMAGES		10000
#define SCROLL_INTERVAL		0.04
#define	AUTO_SCROLL_DELAY	0.5
#define IMAGE_MARGIN		3

@interface ScrollView ()
{
    NSMutableArray *SVUrl;
    NSMutableArray *titles;
    ImageLoader *imageLoader;
}
@end

@implementation ScrollView

@synthesize imageList, items, scrollViewDelegate, flag;

- (void) stopAutoScroll {
    autoScrollStopped = YES;
}

- (void) restartAutoScroll {
    FUNC();
    autoScrollStopped = NO;
}

- (void) restartAutoScrollAfterDelay {
    [self performSelector:@selector(restartAutoScroll)
               withObject:nil
               afterDelay:AUTO_SCROLL_DELAY];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = (id)self;
        self.imageList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) setItems {
    CGRect imageViewFrame = CGRectMake(-IMAGE_WIDTH, 0, IMAGE_WIDTH, IMAGE_HEIGHT);
    CGRect labelViewFrame = CGRectMake(-IMAGE_WIDTH + 2, 75, IMAGE_WIDTH - 4, 26);

    SVUrl = [items objectForKey:@"jacket_url"];
    titles = [items objectForKey:@"artists"];

    for (NSInteger i=0; i<MAX_VIEW_NUM; i++) {
        [self.imageList addObject:[NSString stringWithFormat:@"%d", i]];
        imageViewFrame.origin.x += IMAGE_WIDTH;
        labelViewFrame.origin.x += IMAGE_WIDTH;
        NSString *artworkURL = [SVUrl objectAtIndex:i];
        imageLoader = [ImageLoader sharedInstance];
        UIImage *userImg = [imageLoader cacedImageForUrl:artworkURL];

        CheckButton *btn = [CheckButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:userImg forState:UIControlStateNormal];
        btn.frame = imageViewFrame;
        btn.tag = i + 25 * flag;
        btn.imageEdgeInsets = UIEdgeInsetsMake(IMAGE_MARGIN, IMAGE_MARGIN, IMAGE_MARGIN, IMAGE_MARGIN);
        btn.enabled = YES;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];

        NSString *trackTitle = [[titles objectAtIndex:i] stringByReplacingOccurrencesOfString:@" - " withString:@"\n"];
        UILabel *label = [[UILabel alloc] initWithFrame:labelViewFrame];
        label.numberOfLines = 2;
        label.backgroundColor = [UIColor clearColor];
        [label setFont:[UIFont systemFontOfSize:7.0f]];
        [label setText:trackTitle];

        if (!userImg) {
            [imageLoader loadImage:artworkURL completion:^(UIImage *image){
                SEL selector = @selector(setImages:btn:);
                // シグネチャを作成
                NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:selector];
                // invocationの作成
                CheckButton*local = btn;
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
                [invocation setTarget:self];
                [invocation setArgument:&image atIndex:2];
                [invocation setArgument:&local atIndex:3];
                [invocation setSelector:selector];
                [self performSelectorOnMainThread:@selector(performArtWorkIcon:) withObject:invocation waitUntilDone:YES];
            }];
        }
        [self addSubview:btn];
        [self addSubview:label];
        [self updateScrollViewSetting];
    }
}

- (void)btnAction:(id)sender {
    CheckButton *btn = (CheckButton*)sender;
    [btn setCheckButton];
    // ここで、mainviewのメソッドも呼ぶ。
    // どのボタンが押されたのか分かるように、btn.tagを呼ぶ。
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSString stringWithFormat:@"%d", btn.tag] forKey:@"button_number"];

    if ([btn confirmIsChecked]) {
        [dictionary setObject:@"YES" forKey:@"is_checked"];
    } else {
        [dictionary setObject:@"NO" forKey:@"is_checked"];
    }

    [scrollViewDelegate performSelector:@selector(notificateNumbers:) withObject:dictionary];
}

-(void)performArtWorkIcon:(NSInvocation*)anInvocation
{
	[anInvocation invokeWithTarget:self];
}

- (void)setImages:(UIImage*)image btn:(CheckButton*)btn
{
    [btn setImage:image forState:UIControlStateNormal];
    [self setNeedsDisplay];
    [self setNeedsLayout];
}

- (UIImage*)blankImage
{
	return [UIImage imageNamed:@"blank.jpg"];
}

- (void) updateScrollViewSetting {
    CGSize contentSize = CGSizeMake(0, IMAGE_HEIGHT);
    NSInteger numberOfImages = [SVUrl count];
    
    contentSize.width = IMAGE_WIDTH * numberOfImages;

    self.contentSize = contentSize;
}

typedef enum {
    kScrollDirectionLeft,
    kScrollDirectionRight
} ScrollDirection;

- (NSInteger) addViewIndex:(NSInteger)index incremental:(NSInteger)incremental
{
    return (index + incremental + MAX_VIEW_NUM) % MAX_VIEW_NUM;
}

- (void)scrollWithDirection:(ScrollDirection)scrollDirection{
    NSInteger incremental = 0;
    NSInteger viewIndex = 0;
    NSInteger imageIndex = 0;

    if (scrollDirection == kScrollDirectionLeft) {
        incremental = -1;
        viewIndex = rightViewIndex;
    } else if (scrollDirection == kScrollDirectionRight) {
        incremental = 1;
        viewIndex = leftViewIndex;
    }

    if (scrollDirection == kScrollDirectionLeft) {
        imageIndex = leftImageIndex - 1;
    } else if (scrollDirection == kScrollDirectionRight) {
        imageIndex = leftImageIndex + DISPLAY_VIEW_NUM;
    }

    leftViewIndex = [self addViewIndex:leftViewIndex incremental:incremental];
    rightViewIndex = [self addViewIndex:rightViewIndex incremental:incremental];
}

- (void)setImageList:(NSMutableArray*)list {
    imageList = list;
    
    leftImageIndex = 0;
    leftViewIndex = 0;
    rightViewIndex = MAX_VIEW_NUM - 1;

    [self updateScrollViewSetting];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat position = scrollView.contentOffset.x / IMAGE_WIDTH;
    CGFloat delta = position - (CGFloat)leftImageIndex;
    NSInteger count = (NSInteger)fabs(delta);

    for (int i=0; i < count; i++) {
        if (delta > 0) {
            [self scrollWithDirection:kScrollDirectionRight];
        } else {
            [self scrollWithDirection:kScrollDirectionLeft];
        }
    }
}

// drag is starting
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"stopAutoScroll");
    [self stopAutoScroll];
}

// drag is stopping
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    [self restartAutoScrollAfterDelay];
}

// enable to drag
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"scrollViewDidEndDragging: %d", decelerate);
    if (!decelerate) {
        [self restartAutoScrollAfterDelay];
    }
}

@end