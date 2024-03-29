//
//  LoginViewController.m
//  iTunesSearch
//
//  Created by s_akiba on 12/12/12.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "LoginViewController.h"
#import "SBJson.h"
#import "TabBarController.h"
#import "SideFlipScrollView.h"

#define USER_ADD_URL @"http://neiro.me/api/test/user_add.php"

@interface LoginViewController ()

@end

@implementation LoginViewController
{
    UIButton *btn01;
    UIButton *btn02;
    UIButton *btn03;
    UIButton *btn04;
}
@synthesize facebook;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"backgroundGray"]];
 
    if ([defaults objectForKey:@"FBAccessTokenKey"]
        && [defaults objectForKey:@"FBExpirationDateKey"] && [defaults stringForKey:@"user_id"]) {
        TabBarController *tabBarController = [[TabBarController alloc] init];

        [UIApplication sharedApplication].keyWindow.rootViewController = tabBarController;
    }
    
    SideFlipScrollView *sideFlipScrollView = [[SideFlipScrollView alloc] init];
    sideFlipScrollView.sideFlipDelegate = self;
    [self.view addSubview:sideFlipScrollView];
    [sideFlipScrollView setView];
    
    btn01 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn02 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn03 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn04 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self setButtons:btn01 :0];
    [self setButtons:btn02 :1];
    [self setButtons:btn03 :2];
    [self setButtons:btn04 :3];
    [btn01 setImage:[UIImage imageNamed:@"blueBtn"] forState:UIControlStateNormal];
    
    facebook = [[Facebook alloc] initWithAppId:APP_ID andDelegate:self];
}

- (void)setButtons:(UIButton*)btn:(NSInteger)i {
    [btn setImage:[UIImage imageNamed:@"whiteBtn"] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(110 + i * 30 , 440, 10, 10)];
    [self.view addSubview:btn];
}

- (void) setFacebookLoginButton {
    UIButton *fbloginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fbloginBtn setImage:[UIImage imageNamed:@"connectFB.png"] forState:UIControlStateNormal];
    fbloginBtn.frame = CGRectMake(62, 390, 200, 40);
    [fbloginBtn addTarget:self action:@selector(fblogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fbloginBtn];
}

- (void) scrolledView:(NSNumber*)pageNumber {
    NSInteger number = [pageNumber integerValue];
    switch (number) {
        case 0:
            [btn01 setImage:[UIImage imageNamed:@"blueBtn"] forState:UIControlStateNormal];
            [btn02 setImage:[UIImage imageNamed:@"whiteBtn"] forState:UIControlStateNormal];
            break;
        case 1:
            [btn01 setImage:[UIImage imageNamed:@"whiteBtn"] forState:UIControlStateNormal];
            [btn02 setImage:[UIImage imageNamed:@"blueBtn"] forState:UIControlStateNormal];
            [btn03 setImage:[UIImage imageNamed:@"whiteBtn"] forState:UIControlStateNormal];
            break;
        case 2:
            [btn02 setImage:[UIImage imageNamed:@"whiteBtn"] forState:UIControlStateNormal];
            [btn03 setImage:[UIImage imageNamed:@"blueBtn"] forState:UIControlStateNormal];
            [btn04 setImage:[UIImage imageNamed:@"whiteBtn"] forState:UIControlStateNormal];
            break;
        case 3:
            [btn03 setImage:[UIImage imageNamed:@"whiteBtn"] forState:UIControlStateNormal];
            [btn04 setImage:[UIImage imageNamed:@"blueBtn"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (void)fblogin {
    permissions =  [[NSArray alloc] initWithObjects:
                    @"user_about_me",
                    @"publish_stream",
                    @"user_photos",
                    nil];
    [facebook authorize:permissions];
}

//ユーザの情報を取得するメソッド
- (void)getUserInfo{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [facebook requestWithGraphPath:@"me" andDelegate:self];
}

//ログインが完了したときに呼ばれるデリゲートメソッド
- (void)fbDidLogin {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    [self getUserInfo];
}

//ログインできなかったときに呼ばれるデリゲートメソッド
-(void)fbDidNotLogin:(BOOL)cancelled {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

//ログアウトしたときに呼ばれるデリゲートメソッド
- (void)fbDidLogout {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }
}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
}

//requestが成功してロードされた時に呼び出されるデリゲートメソッド
//getuserinfoメソッドで取得したデータをここで取得する。（ユーザの名前等）
- (void)request:(FBRequest *)request didLoad:(id)result {
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];//
    }
    DEBUGLOG(@"result:%@", result);

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *user_name = [result objectForKey:@"name"];
    NSString *facebook_id = [result objectForKey:@"id"];
    NSString *image_url = [NSString stringWithFormat:@"%@%@%@", IMG_PIC, facebook_id, @"/picture&type=normal"];
    NSString *f_aces_token = [facebook accessToken];
    
    [defaults setObject:user_name forKey:@"name"];
    [defaults setObject:facebook_id forKey:@"id"];
    [defaults synchronize];

    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:user_name forKey:@"user_name"];
    [dictionary setValue:facebook_id forKey:@"facebook_id"];
    [dictionary setValue:image_url forKey:@"image_url"];
    [dictionary setValue:f_aces_token forKey:@"f_aces_token"];
    
    NSURL *url = [[NSURL alloc] initWithString:USER_ADD_URL];
    ASIFormDataRequest *asiFormRequest = [[ASIFormDataRequest alloc] initWithURL:url];

    [asiFormRequest setPostValue:[dictionary JSONRepresentation] forKey:@"user_add"];
    [asiFormRequest addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    [asiFormRequest setDelegate:self];
    // not asynchronous
    [asiFormRequest startSynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{


}

- (void)requestStarted:(ASIHTTPRequest *)request {
    FUNC();
}

- (void) requestRedirected:(ASIHTTPRequest *)request {
    FUNC();
}

- (void) request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders {
    NSDictionary *dictionay = [request responseHeaders];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[dictionay objectForKey:@"user_id"] forKey:@"user_id"];
    DEBUGLOG(@"dictionary:%@", [dictionay objectForKey:@"user_id"]);
    [defaults synchronize];

    TabBarController *tabBarController = [[TabBarController alloc] init];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarController;
}

- (void) requestDone:(id)sender {

}

- (void) requestFailed:(id)sender {
}

//Requestが失敗したときに呼ばれるデリゲートメソッド
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showWaitingView {
    CGRect r = [[UIScreen mainScreen] bounds];
    WaitingView *waitingView = [[WaitingView alloc] initWithFrame:r];
    [self.view addSubview:waitingView];
}

@end
