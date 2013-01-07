//
//  AddPocketViewController.m
//  iTunesSearch
//
//  Created by s_akiba on 12/12/10.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "AddPocketViewController.h"
#import "PostToServer.h"
#import "SBJson.h"
#import "DiscRotationView.h"

#define POCKET_URL @"http://neiro.me/api/test/createPocket.php"

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
    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"backgroundGray"]]];

    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, 200, 35)];
    [labelTitle setFont:[UIFont systemFontOfSize:14.0f]];
    [labelTitle setText:@"プレイリスト名"];
    [labelTitle setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:labelTitle];

    textField = [[UITextField alloc] initWithFrame:CGRectMake(40, 60, 240, 50)];
    textField.delegate = (id)self;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:textField];

    UIButton *addPocket = [UIButton buttonWithType:UIButtonTypeCustom];
    [addPocket setFrame:CGRectMake(200, 115, 80, 40)];
    [addPocket setImage:[UIImage imageNamed:@"addPocket"] forState:UIControlStateNormal];
    [addPocket addTarget:self action:@selector(addPocket) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addPocket];
    
    UIButton *customView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 30)];
    [customView setBackgroundImage:[UIImage imageNamed:@"cancelBtn"] forState:UIControlStateNormal];
    [customView addTarget:self action:@selector(modalClose) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* buttonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    self.navigationItem.leftBarButtonItem = buttonItem;

    DiscRotationView *discImage = [[DiscRotationView alloc] initWithFrame:CGRectMake(200, 200, 50, 50)];
    [self.view addSubview:discImage];
    [discImage startRotation];
}

-(BOOL)textFieldShouldReturn:(UITextField*)txField {
    [textField resignFirstResponder];
    return YES;
}

-(void) modalClose {
    [self dismissModalViewControllerAnimated:YES];
}

- (void) addPocket {
    if ([textField.text isEqualToString:@""] || !textField.text) {
        FUNC();
        [self alert];
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *user_id = [defaults objectForKey:@"user_id"];

        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:textField.text forKey:@"pocket_title"];
        [dictionary setValue:user_id forKey:@"user_id"];

        NSURL *url = [[NSURL alloc] initWithString:POCKET_URL];

        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];

        [request setPostValue:[dictionary JSONRepresentation] forKey:@"pocket"];
        [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
//      [request setDelegate:self];
        [request startAsynchronous];
        [self modalClose];
    }
}

- (void) alert {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"alert"
                                                        message:@"プレイリスト名を入力してください。"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
    [alertView show];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
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
}

- (void) requestFailed:(id)sender {
}

@end