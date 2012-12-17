//
//  AddPocketViewController.h
//  iTunesSearch
//
//  Created by s_akiba on 12/12/10.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface AddPocketViewController : UIViewController <ASIHTTPRequestDelegate>
{

}
@property (nonatomic, retain) id addPocketDelegate;

@end