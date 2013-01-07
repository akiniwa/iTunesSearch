//
//  DiscRotationView.m
//  iTunesSearch
//
//  Created by s_akiba on 13/01/07.
//  Copyright (c) 2013年 s_akiba. All rights reserved.
//

#import "DiscRotationView.h"
#import <QuartzCore/QuartzCore.h>

@implementation DiscRotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        discImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [discImage setImage:[UIImage imageNamed:@"discImage"]];
        [self addSubview:discImage];
    }
    return self;
}

- (void) startRotation {
    [self runSpinAnimationOnView:discImage duration:0.3f rotations:M_PI*0.3f repeat:100.0f];
}

- (void) runSpinAnimationOnView:(UIImageView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;
{
    CABasicAnimation* rotationAnimation;
    
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.delegate = self;
    rotationAnimation.toValue = [NSNumber numberWithFloat:rotations];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    //    rotationAnimation.repeatCount = repeat;
    rotationAnimation.repeatCount = HUGE_VALF;
    
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.removedOnCompletion = NO;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)animationDidStart:(CAAnimation *)anim {
    FUNC();
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    FUNC();
}

@end