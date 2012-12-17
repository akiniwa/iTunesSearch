//
//  MovingScrollView.m
//  iTunesSearch
//
//  Created by s_akiba on 12/11/12.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "MovingScrollView.h"

#define IMAGE_WIDTH			80
#define IMAGE_HEIGHT		80
#define DISPLAY_VIEW_NUM	4
#define MAX_VIEW_NUM		(DISPLAY_VIEW_NUM+2)
#define MAX_SCROLLABLE_IMAGES		10000
#define SCROLL_INTERVAL		0.04
#define	AUTO_SCROLL_DELAY	0.5
#define IMAGE_MARGIN		3

@implementation MovingScrollView

@synthesize viewList, imageList, timer, circulated;

- (void)stopAutoScroll
{
	autoScrollStopped = YES;
}

- (void)restartAutoScroll
{
	autoScrollStopped = NO;
}

- (void)restartAutoScrollAfterDelay
{
	[self performSelector:@selector(restartAutoScroll)
			   withObject:nil
			   afterDelay:AUTO_SCROLL_DELAY];
}

- (void) timerDidFire:(NSTimer*)timer {
    DEBUGLOG(@"timer is acrive");
    if (autoScrollStopped) {
        return;
    }
    // contentOffset:スクロール画面の初期位置。
    CGPoint p = self.contentOffset;
    p.x = p.x + 1;

    if (p.x < IMAGE_WIDTH * MAX_SCROLLABLE_IMAGES) {
        self.contentOffset = p;
    }
}

- (void) touchedButton:(id)sender forEvent:(UIEvent *)event {
    UITouch *touch = [event.allTouches anyObject];
    if (touch.phase == UITouchPhaseBegan) {
        [self stopAutoScroll];
    } else if (touch.phase == UITouchPhaseEnded) {
        NSInteger viewIndex = [sender tag];
        NSInteger imageIndex = (leftImageIndex + (MAX_VIEW_NUM + viewIndex - leftImageIndex) % MAX_VIEW_NUM - 1) % [imageList count];
        NSLog(@"imageIndex=%d", imageIndex);
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
        self.delegate = (id)self;
        circulated = YES;
		autoScrollStopped = NO;

    }
    return self;
}

- (void) showView {

    NSMutableArray* array = [NSMutableArray array];
    
    CGRect imageViewFrame = CGRectMake(-IMAGE_WIDTH, 0, IMAGE_WIDTH, IMAGE_HEIGHT);

    for (int i=0; i < MAX_VIEW_NUM; i++) {
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.frame = imageViewFrame;
        view.backgroundColor = [UIColor redColor];

        [view setImage:[UIImage imageNamed:@"simg1.jpg"] forState:UIControlStateNormal];
        view.tag = i;
        view.imageEdgeInsets = UIEdgeInsetsMake(IMAGE_MARGIN, IMAGE_MARGIN, IMAGE_MARGIN, IMAGE_MARGIN);

        [view setBackgroundImage:[UIImage imageNamed:@"background"]
                        forState:UIControlStateNormal];

        [view addTarget:self
                 action:@selector(touchedButton:forEvent:)
       forControlEvents:UIControlEventAllEvents];

        [array addObject:view];
        imageViewFrame.origin.x += IMAGE_WIDTH;

        [self addSubview:view];
    }

    self.viewList = array;

    if (circulated) {
        [self stopAutoScroll];
        if ([self.timer isValid]) {
          [self.timer invalidate];
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:SCROLL_INTERVAL
                                                      target:self
                                                    selector:@selector(timerDidFire:)
                                                    userInfo:nil
                                                     repeats:YES];
        [self restartAutoScrollAfterDelay];
    }
}

- (UIImage*)blankImage
{
	return [UIImage imageNamed:@"blank.jpg"];
}

- (UIImage*)imageAtIndex:(NSInteger)index {
    NSInteger numberOfImages = [self.imageList count];

    UIImage *image = nil;

    if (self.circulated) {
        if (0 <= index && index <= MAX_SCROLLABLE_IMAGES - 1) {
            index = (index + numberOfImages) % numberOfImages;
        }
    }

    if (0 <= index && index < numberOfImages) {
        image = [self.imageList objectAtIndex:index];
    } else {
        image = [self blankImage];
    }
    return image;
}

- (void) updateScrollViewSetting {
    CGSize contentSize = CGSizeMake(0, IMAGE_HEIGHT);
	NSInteger numberOfImages = [imageList count];

	if (self.circulated) {
		contentSize.width = IMAGE_WIDTH * MAX_SCROLLABLE_IMAGES;
		CGPoint contentOffset = CGPointZero;
		contentOffset.x = ((MAX_SCROLLABLE_IMAGES-numberOfImages)/2) * IMAGE_WIDTH;
		CGRect viewFrame = CGRectMake(
                                      contentOffset.x - IMAGE_WIDTH, 0, IMAGE_WIDTH, IMAGE_HEIGHT);
		for (UIButton* view in self.viewList) {
			view.frame = viewFrame;
			viewFrame.origin.x += IMAGE_WIDTH;
		}

		leftImageIndex = contentOffset.x / IMAGE_HEIGHT;
		self.contentOffset = contentOffset;

		UIButton* leftView = [self.viewList objectAtIndex:leftViewIndex];
		[leftView setImage:[self imageAtIndex:DISPLAY_VIEW_NUM]
				  forState:UIControlStateNormal];

	} else {
		contentSize.width = IMAGE_WIDTH * numberOfImages;
	}

	self.contentSize = contentSize;
	self.showsHorizontalScrollIndicator = !self.circulated;
}

typedef enum {
    kScrollDirectionLeft,
	kScrollDirectionRight
} ScrollDirection;

- (void) scrollWithDirection:(ScrollDirection)scrollDirection {
    NSInteger incremental = 0;
    NSInteger viewIndex = 0;
    NSInteger imageIndex = 0;
    
    if (scrollDirection == kScrollDirectionLeft) {
        incremental = -1;
        viewIndex = rightViewIndex;
    } else if (scrollDirection == kScrollDirectionRight) {
        incremental = 1;
        viewIndex = leftImageIndex;
    }
    
    // change position
    UIButton *view = [self.viewList objectAtIndex:viewIndex];
    CGRect frame = view.frame;
    frame.origin.x += IMAGE_WIDTH * MAX_VIEW_NUM * incremental;
    view.frame = frame;
    
    // change image
    leftImageIndex = leftImageIndex + incremental;
    
    if (scrollDirection == kScrollDirectionLeft) {
        imageIndex = leftImageIndex - 1;
    } else if (scrollDirection == kScrollDirectionRight) {
        imageIndex = leftImageIndex + DISPLAY_VIEW_NUM;
    }
    
    [view setImage:[self imageAtIndex:imageIndex]
          forState:UIControlStateNormal];
    
    leftImageIndex = [self addViewIndex:leftImageIndex incremental:incremental];
    rightViewIndex = [self addViewIndex:rightViewIndex incremental:incremental];
}

- (void) setImageList:(NSArray *)list {
    imageList = list;
    
    leftImageIndex = 0;
    leftViewIndex = 0;
    rightViewIndex = MAX_VIEW_NUM;
    
    for (int i=0; i < MAX_VIEW_NUM; i++) {
        UIButton *view = [self.viewList objectAtIndex:i];
        [view setImage:[self blankImage]
              forState:UIControlStateNormal];
    }
    
    NSInteger index = 1;
    for (UIImage *image in imageList) {
        UIButton *view = [self.viewList objectAtIndex:index];
        [view setImage:image
              forState:UIControlStateNormal];
        index++;
        if (index > DISPLAY_VIEW_NUM) {
            break;
        }
    }
    
    UIButton *rightView = [self.viewList objectAtIndex:MAX_VIEW_NUM - 1];
    [rightView setImage:[self imageAtIndex:DISPLAY_VIEW_NUM]
               forState:UIControlStateNormal];
    
    [self updateScrollViewSetting];
}

- (NSInteger)addViewIndex:(NSInteger)index incremental:(NSInteger)incremental
{
	return (index + incremental + MAX_VIEW_NUM) % MAX_VIEW_NUM;
}

- (void) scrollViewDidScroll:(UIScrollView *)_scrollView {
    CGFloat position = _scrollView.contentOffset.x / IMAGE_WIDTH;
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

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopAutoScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	NSLog(@"scrollViewDidEndDecelerating");
	[self restartAutoScrollAfterDelay];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	NSLog(@"scrollViewDidEndDragging: %d", decelerate);
	if (!decelerate) {
		[self restartAutoScrollAfterDelay];
	}
}

@end