//
//  CheckButton.h
//  iTunesSearch
//
//  Created by s_akiba on 12/11/28.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckButton : UIButton
{
    BOOL is_checked;
    UIImageView *view;
}

//- (UIImageView*)setCheckButton;
- (void)setCheckButton;
- (BOOL)confirmIsChecked;

@end
