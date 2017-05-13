//
//  AppDelegate.m
//  DAN
//
//  Created by EMPty on 1/2/16.
//  Copyright (c) 2016 EMPty. All rights reserved.
//

#import "AppDelegate.h"
#import <RongIMKit/RongIMKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#import <BmobSDK/Bmob.h>
#import "loginViewController.h"
@interface AppDelegate ()<BMKGeneralDelegate,RCIMUserInfoDataSource>

@property (nonatomic,strong) BMKMapManager *mapManager;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //初始化bmob
    [Bmob registerWithAppKey:@"481f4f020f65ca2c7180cb3db0508710"];
    // 要使用百度地图先实例化 BMKMapManager
    self.mapManager = [[BMKMapManager alloc]init];
    
    // 如果要关注网络及授权验证事件，请设定 generalDelegate 参数
    BOOL ret = [self.mapManager start:@"6Xdmc0SjNQoyrMmKULZd5qN3dcAhLRCf" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed");
    }
    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    loginViewController *login=[[loginViewController alloc]init];
    //设置控制器为Window的根控制器
    self.window.rootViewController=login;
    
    
    //2.设置Window为主窗口并显示出来
    [self.window makeKeyAndVisible];
    return YES;

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"百度地图联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"百度地图授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}
@end
