//
//  LoginViewController.h
//  iTunesSearch
//
//  Created by s_akiba on 12/12/12.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "Facebook.h"

@interface LoginViewController : UIViewController<FBRequestDelegate,FBDialogDelegate,FBSessionDelegate, ASIHTTPRequestDelegate>
{
    NSArray *permissions;
}
@property (nonatomic, retain) Facebook *facebook;

@end
