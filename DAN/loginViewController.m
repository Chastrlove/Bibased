//
//  loginViewController.m
//  运动社交
//
//  Created by Jay on 2017/4/18.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "loginViewController.h"
#import "textFieldBackground.h"
#import <RongIMKit/RongIMKit.h>
#import <BmobSDK/Bmob.h>
#import "AppDelegate.h"
#import "RecordViewController.h"
#import "discoverViewController.h"
#import "ChatViewController.h"
#import "personTableViewController.h"
#import "MBProgressHUD.h"

@interface loginViewController (){
    MBProgressHUD *HUD;
}
@property (nonatomic,strong) UITextField *account;
@property (nonatomic,strong) UITextField *password;
@property (nonatomic,strong) UIButton *loginButton;
@property (nonatomic,strong) UIView*background;
@property (strong, nonatomic) NSMutableArray *othername;
@property (strong, nonatomic) NSString *token;
@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1]];
    _background=[[textFieldBackground alloc] initWithFrame:CGRectMake(20, 200, self.view.frame.size.width-40, 100)];
    [_background setBackgroundColor:[UIColor whiteColor]];
    [[_background layer] setCornerRadius:5];
    [[_background layer] setMasksToBounds:YES];
    [self.view addSubview:_background];
    _account=[[UITextField alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-40, 50)];
    [_account setBackgroundColor:[UIColor clearColor]];
    _account.placeholder=[NSString stringWithFormat:@"Username"];
    _account.layer.cornerRadius=5.0;
    [_background addSubview:_account];
    _password=[[UITextField alloc] initWithFrame:CGRectMake(10, 50, self.view.frame.size.width-40, 50)];
    [_account setBackgroundColor:[UIColor clearColor]];
    _password.placeholder=[NSString stringWithFormat:@"Password"];
    _password.layer.cornerRadius=5.0;
    [_password setSecureTextEntry:YES];
    [_background addSubview:_password];
    _loginButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_loginButton setFrame:CGRectMake(20, 320, self.view.frame.size.width-40, 50)];
    [_loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [_loginButton setBackgroundColor:[UIColor colorWithRed:51/255.0 green:102/255.0 blue:255/255.0 alpha:1]];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(logInto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
}

-(void) logInto{
    //[self initTab];
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        [BmobUser loginWithUsernameInBackground:_account.text
                                       password:_password.text block:^(BmobUser *user, NSError *error) {
                                           if (user) {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                                               });
                                               NSLog(@"%@",user);
                                               appDelegate.currentUserId=[user objectForKey:@"userId"];
                                               _token=[user objectForKey:@"token"];
                                               //QD4ST7/LkIVfn6zECxE/7vNXW5cTL74Gbsf0zW6YtQgI4KbIOm9TXK2+sq7g8TN6mnOzak87fabOj9Gub1M4jw==  马晨杰
                                               //PW3vD+tICHX5UKiX9VaLfBtjRnS/nB/WqyV5hYpTJxRMBdVdXrUTzNAZC6FbOfzkRzfSDSbtaOavGuo14RGFBw==  喵星人
                                               [[RCIM sharedRCIM] initWithAppKey:@"6tnym1br65vb7"];
                                               [[RCIM sharedRCIM] connectWithToken:_token
                                                                           success:^(NSString *userId) {
                                                                               NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
                                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                                   [self getuserData:userId];
                                                                                   [[RCIM sharedRCIM] setUserInfoDataSource:self];
                                                                                   [self initTab];
                                                                                   
                                                                               });
                                                                               
                                                                           } error:^(RCConnectErrorCode status) {
                                                                               NSLog(@"登陆的错误码为:%d", status);
                                                                           } tokenIncorrect:^{
                                                                               //token过期或者不正确。
                                                                               //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                                                                               //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                                                                               NSLog(@"token错误");
                                                                           }];
                                           } else {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                                               });
                                               NSLog(@"%@",error);
                                           }
                                       }];
        
    });
    
}
-(void) initTab{
    //a.初始化一个tabBar控制器
    UITabBarController *tb=[[UITabBarController alloc]init];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:75.0/255.0 green:159.0/255.0 blue:24.0/255.0 alpha:0.5]];
    
    
    //b.创建子控制器
    RecordViewController *c1=[[RecordViewController alloc]init];
    c1.tabBarItem.title=@"主页";
    c1.tabBarItem.image=[UIImage imageNamed:@"home_tarBar"];
    
    ChatViewController *c2=[[ChatViewController alloc]init];
    c2.tabBarItem.title=@"消息";
    c2.tabBarItem.image=[UIImage imageNamed:@"message_tarBar"];
    //c2.tabBarItem.badgeValue=@"123";
    
    discoverViewController *c3=[[discoverViewController alloc]init];
    c3.tabBarItem.title=@"动态";
    c3.tabBarItem.image=[UIImage imageNamed:@"crown_tarBar"];
    
    personTableViewController *c4=[[personTableViewController alloc]init];
    c4.tabBarItem.title=@"设置";
    c4.tabBarItem.image=[UIImage imageNamed:@"setting_tarBar"];
    
    
    
    UINavigationController * a1 = [[UINavigationController alloc]initWithRootViewController:c1];
    UINavigationController * a2 = [[UINavigationController alloc]initWithRootViewController:c2];
    UINavigationController * a3 = [[UINavigationController alloc]initWithRootViewController:c3];
    UINavigationController * a4 = [[UINavigationController alloc]initWithRootViewController:c4];
    
    
    //c.添加子控制器到ITabBarController中
    //c.1第一种方式
    //    [tb addChildViewController:c1];
    //    [tb addChildViewController:c2];
    
    //c.2第二种方式
    tb.viewControllers=@[a1,a2,a3,a4];
    [self presentModalViewController:tb animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    
    RCUserInfo *user=[[RCUserInfo alloc]init];
    user.userId=userId;
    for(NSDictionary *dc in _othername){
        if([dc objectForKey:@"userId"]==userId){
            user.name=[dc objectForKey:@"username"];
            break;
        }
    }
    return completion(user);
}
//返回会话不更新数据需完善
-(void)getuserData:(NSString*) userId{
    _othername = [[NSMutableArray alloc] init];
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"_User"];
    bquery.cachePolicy = kBmobCachePolicyNetworkElseCache;
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [obj objectForKey:@"userId"], @"username",
                                 [obj objectForKey:@"username"], @"userId",
                                 nil];
            if([obj objectForKey:@"username"]==userId){
                
            }else{
                [_othername addObject:dic];
            }
            
        }
        NSLog(@"通讯录获取完毕");
    }];
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
