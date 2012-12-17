//
//  AddPocketViewController.m
//  iTunesSearch
//
//  Created by s_akiba on 12/12/10.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "AddPocketViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PostToServer.h"
#import "SBJson.h"

#define POCKET_URL @"http://neiro.me/api/pocket.php"

@interface AddPocketViewController()
{
    UITextField *textField;
}

@end

@implementation AddPocketViewController

@synthesize addPocketDelegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *addPocket = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addPocket setFrame:CGRectMake(140, 120, 80, 40)];
    [addPocket setTitle:@"pocket" forState:UIControlStateNormal];
    [addPocket addTarget:self action:@selector(addPocket) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addPocket];
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(40, 40, 250, 80)];
    textField.delegate = (id)self;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:textField];

    UIButton *customView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 30)];
    [customView setBackgroundImage:[UIImage imageNamed:@"cancelBtn.png"] forState:UIControlStateNormal];
    [customView addTarget:self action:@selector(modalClose) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* buttonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    self.navigationItem.leftBarButtonItem = buttonItem;
}

-(BOOL)textFieldShouldReturn:(UITextField*)txField {
    FUNC();
    [textField resignFirstResponder];
    return YES;
}

-(void) modalClose {
    [self dismissModalViewControllerAnimated:YES];
}

- (void) addPocket {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [defaults objectForKey:@"user_id"];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:textField.text forKey:@"pocket_title"];
    [dictionary setValue:user_id forKey:@"user_id"];

    NSURL *url = [[NSURL alloc] initWithString:POCKET_URL];

    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];

    [request setPostValue:[dictionary JSONRepresentation] forKey:@"pocket"];

    [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    DEBUGLOG(@"responseString:%@", responseString);
}

- (void)requestStarted:(ASIHTTPRequest *)request {
}

- (void) requestRedirected:(ASIHTTPRequest *)request {
}

- (void) request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders {
    DEBUGLOG(@"%@:%@", request, responseHeaders);
}

- (void) requestDone:(id)sender {
    NSLog(@"done, sender:%@", [sender class]);
}

- (void) requestFailed:(id)sender {
    NSLog(@"failed, sender:%@", [sender class]);
}


@end