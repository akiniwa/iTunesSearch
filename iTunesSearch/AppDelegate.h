//
//  AppDelegate.h
//  iTunesSearch
//
//  Created by s_akiba on 12/10/25.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Reachability;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    Reachability* hostReach;
    Reachability* internetReach;
    Reachability* wifiReach;
}
@property (strong, nonatomic) UIWindow *window;

@end
