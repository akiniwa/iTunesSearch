//
//  UserImageView.m
//  iTunesSearch
//
//  Created by s_akiba on 13/01/07.
//  Copyright (c) 2013年 s_akiba. All rights reserved.
//

#import "UserImageView.h"
#import "HttpClient.h"
#import "ImageLoader.h"

@implementation UserImageView
{
    UIActivityIndicatorView *activity;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void) setImageWithUrl:(NSString*)imageUrl {
    ImageLoader* imageLoader = [ImageLoader sharedInstance];
    UIImage *jacketImage = [imageLoader cacedImageForUrl:imageUrl];
    [self setImage:jacketImage];

    if (!jacketImage) {
        activity = [self activityIndicator];
        [self addSubview:activity];
        [activity startAnimating];

        __weak UserImageView *_self = self;
        [imageLoader loadImage:imageUrl completion:^(UIImage *image) {
            [_self performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
        }];
    }
}

- (void)setImage:(UIImage *)image {
    [super setImage:image];
    [activity stopAnimating];
}

- (UIActivityIndicatorView*)activityIndicator {
    CGRect r = self.frame;
    activity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(r.origin.x, r.origin.y, r.size.width, r.size.height)];
    [activity setBackgroundColor:[UIColor clearColor]];
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [activity hidesWhenStopped];
    return activity;
}

@end
