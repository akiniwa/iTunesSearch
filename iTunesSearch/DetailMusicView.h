//
//  DetailMusicView.h
//  iTunesSearch
//
//  Created by s_akiba on 12/12/26.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicView.h"

@interface DetailMusicView : MusicView

@property (nonatomic, retain) UIButton *pauseButton;

- (void)removeObserverFromMusicView;


@end