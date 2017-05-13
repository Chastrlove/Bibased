//
//  KZStatusView.h
//  MapDemo
//
//  Created by ORCHAN on 15/7/13.
//  Copyright (c) 2015年 ORCHAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZTimerLabel.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

@interface KZStatusView : UIViewController

// 距离
@property (weak, nonatomic) IBOutlet UILabel *distance;
//步数
@property (weak, nonatomic) IBOutlet UILabel *step;

// 平均速度
@property (weak, nonatomic) IBOutlet UILabel *avgSpeed;

// 目前速度
@property (weak, nonatomic) IBOutlet UILabel *currSpeed;

// 计时器
@property (weak, nonatomic) IBOutlet MZTimerLabel *timerLabel;

// 纬度
@property (weak, nonatomic) IBOutlet UILabel *latituteLabel;

// 经度
@property (weak, nonatomic) IBOutlet UILabel *longtituteLabel;

// 与上一个点的距离
@property (weak, nonatomic) IBOutlet UILabel *distanceWithPreLoc;

// 是否打开百度地理位置服务
@property (weak, nonatomic) IBOutlet UILabel *startLocatonServiceLabel;

// 是否停止百度地理位置复位
@property (weak, nonatomic) IBOutlet UILabel *stopLocatonServiceLabel;

// 是否已经插上开始的旗帜
@property (weak, nonatomic) IBOutlet UILabel *startPointLabel;

// 是否已经插上结束的旗帜
@property (weak, nonatomic) IBOutlet UILabel *stopPointLabel;

// 累计用时
@property (weak, nonatomic) IBOutlet UILabel *sumTime;
@end
