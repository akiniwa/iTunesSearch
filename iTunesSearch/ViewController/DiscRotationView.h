//
//  DiscRotationView.h
//  iTunesSearch
//
//  Created by s_akiba on 13/01/07.
//  Copyright (c) 2013年 s_akiba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscRotationView : UIView
{
    UIImageView *discImage;
}
- (void)startRotation;
- (void)stopRotation;

@end
