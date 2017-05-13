//
//  NextViewController.m
//  DAN
//
//  Created by Jay on 1/2/16.
//  Copyright (c) 2016 Jay. All rights reserved.
//

#import "NextViewController.h"
#import "StepManager.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#import "KZStatusView.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobFile.h>
#import "AppDelegate.h"
@interface NextViewController ()<BMKMapViewDelegate, BMKLocationServiceDelegate>
{
    
    NSTimer *_timer;
    UILabel *lable;
    NSMutableArray* _service;
    NSMutableArray* _characteristicList;
    CBCharacteristic* _chosenCh;
    UIBarButtonItem* _right;
    UIButton *_shareButton;
    
}
#define DeviceWidth  [[UIScreen mainScreen]bounds].size.width
#define DeviceHeight [[UIScreen mainScreen]bounds].size.height
typedef enum : NSUInteger {
    TrailEnd,
    TrailStart
} Trail;
/** 百度定位地图服务 */
@property (nonatomic, strong) BMKLocationService *bmkLocationService;

/** 百度地图View */
@property (nonatomic,strong) BMKMapView *mapView;

/** 半透明状态显示View */
@property (nonatomic,strong) KZStatusView *statusView;

/** 记录上一次的位置 */
@property (nonatomic, strong) CLLocation *preLocation;

/** 位置数组 */
@property (nonatomic, strong) NSMutableArray *locationArrayM;

/** 轨迹线 */
@property (nonatomic, strong) BMKPolyline *polyLine;

/** 轨迹记录状态 */
@property (nonatomic, assign) Trail trail;

/** 起点大头针 */
@property (nonatomic, strong) BMKPointAnnotation *startPoint;

/** 终点大头针 */
@property (nonatomic, strong) BMKPointAnnotation *endPoint;

/** 累计步行时间 */
@property (nonatomic,assign) NSTimeInterval sumTime;

/** 累计步行距离 */
@property (nonatomic,assign) CGFloat sumDistance;
@end

@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self.view addSubview:lable];
    //    BMKMapView* mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    //    self.view = mapView;
    // 初始化百度位置服务
    [self initBMLocationService];
    
    // 初始化导航栏的一些属性
    [self setupNavigationProperty];
    
    // 初始化 状态信息 控制器
    self.statusView = [[KZStatusView alloc]init];
    
    // 初始化地图窗口
    self.mapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
    
    // 设置MapView的一些属性
    [self setMapViewProperty];
    
    //具有层次关系
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.statusView.view];
    [self setupShareButton];
    
}


/**
 获取步数
 */
- (void)getStepNumber
{
    self.statusView.step.text = [NSString stringWithFormat:@"%ld步",[StepManager sharedManager].step];
}


//整形判断
- (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}




- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error

{
    
    
    for (CBService* service in peripheral.services)
    {
        NSArray* includedservices = service.includedServices;
        NSLog(@"服务service：%@",includedservices);
        //查询服务的特征值
        [peripheral discoverCharacteristics:nil forService:service];
        
        
    }
    
    
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error

{
    
    for (CBCharacteristic * characteristic in service.characteristics)
    {
        
        _chosenCh = characteristic;
        
        
        NSLog(@"%@",[_chosenCh.UUID UUIDString]);
        NSLog(@"%@",_chosenCh);
        
        [_characteristicList addObject:characteristic];
        
        NSLog(@"特征值：%@",characteristic);
    }
#pragma mark-很重要
    //很重要  打开广播
    [_presentPeripheral setNotifyValue:YES forCharacteristic:_chosenCh];
    
    //    [_tableView reloadData];
}




//-(NSData*)stringToByte:(NSString*)string
//{
//
//
//    NSString *hexString=[[string uppercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
//    if ([hexString length]%2!=0) {
//        return nil;
//    }
//    Byte tempbyt[1]={0};
//    NSMutableData* bytes=[NSMutableData data];
//    for(int i=0;i<[hexString length];i++)
//    {
//        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
//        int int_ch1;
//        if(hex_char1 >= '0' && hex_char1 <='9')
//            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
//        else if(hex_char1 >= 'A' && hex_char1 <='F')
//            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
//        else
//            return nil;
//        i++;
//
//        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
//        int int_ch2;
//        if(hex_char2 >= '0' && hex_char2 <='9')
//            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
//        else if(hex_char2 >= 'A' && hex_char2 <='F')
//            int_ch2 = hex_char2-55; //// A 的Ascll - 65
//        else
//            return nil;
//
//        tempbyt[0] = int_ch1+int_ch2;  ///将转化后的数放入Byte数组里
//        [bytes appendBytes:tempbyt length:1];
//    }
//    return bytes;
//}
//
//- (void)getData
//{
//    NSLog(@"开始get");
//    //    _chosenCh.isNotifying = YES;
//    [_presentPeripheral readValueForCharacteristic:_chosenCh];
//
//}
//
//
//
//- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
//{
//    const char *hexBytesLight = [characteristic.value bytes];
//    //NSLog(@"%@",characteristic.value);
//    NSString *pre = [NSString stringWithUTF8String:hexBytesLight];
//    NSString *dataStr = [NSString stringWithFormat:@"%@",pre];
//    NSLog(@"%@",dataStr);
////    NSLog(@"%d",[characteristi]);
////    NSLog(@"%@",[NSString alloc]ini)
//
//    char a = hexBytesLight[0];//x
//    char b = hexBytesLight[1];//y
//    char c = hexBytesLight[2];//z
//
////    NSNumber* am = [[NSNumber alloc]initWithFloat:[a/7.0 intValue]];
//    NSLog(@"x轴%d y轴%d z轴%d",a,b,c);
//
//}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;//加蓝牙的时候要删掉
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
    self.bmkLocationService.delegate = self;
    
    self.navigationController.navigationBar.barStyle    = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
    self.bmkLocationService.delegate = nil;
}

- (void)viewWillLayoutSubviews
{
    self.statusView.view.frame = CGRectMake(20, DeviceHeight - 170, 338, 150);
}

#pragma mark - Customize Method

/**
 *  设置导航栏的一些属性
 */
- (void)setupNavigationProperty
{
    // 导航栏中部标题
    self.title = @"跑步记录仪";
    // 导航栏右侧按钮
    _right = [[UIBarButtonItem alloc]initWithTitle:@"开始" style:UIBarButtonItemStylePlain target:self action:@selector(control)];
    
    self.navigationItem.rightBarButtonItem = _right;
}

- (void)control
{
    if ([_right.title isEqualToString:@"开始"]) {
        _right.title = @"结束";
        [self startTrack];
    }else{
        _right.title = @"开始";
        [self stopTrack];
        
    }
}
/**
 *  设置分享按钮
 */
-(void)setupShareButton
{
    _shareButton = [[UIButton alloc]initWithFrame:CGRectMake(330, 70, 40, 40)];
    [_shareButton setBackgroundImage:[UIImage imageNamed:@"icon_share.png"] forState:UIControlStateNormal];
    _shareButton.hidden = YES;
    [_shareButton addTarget:self action:@selector(shareRun) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_shareButton];
}


/**
 分享实现
 */
-(void)shareRun
{
    NSLog(@"share");
    //TODO: 分享功能
}

/**
 *  初始化百度位置服务
 */
- (void)initBMLocationService
{
    // 初始化位置百度位置服务
    self.bmkLocationService = [[BMKLocationService alloc] init];
    
    //设置更新位置频率(单位：米;必须要在开始定位之前设置)
    //废弃
    //[BMKLocationService setLocationDistanceFilter:5];
    //[BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBest];
    self.bmkLocationService.distanceFilter=5;
    self.bmkLocationService.desiredAccuracy=kCLLocationAccuracyBest;
    [self.bmkLocationService startUserLocationService];
    
}

/**
 *  设置 百度MapView的一些属性
 */
- (void)setMapViewProperty
{
    // 显示定位图层
    self.mapView.showsUserLocation = YES;
    
    // 设置定位模式
    self.mapView.userTrackingMode = BMKUserTrackingModeHeading;
    
    // 允许旋转地图
    self.mapView.rotateEnabled = YES;
    
    // 显示比例尺
    //    self.bmkMapView.showMapScaleBar = YES;
    //    self.bmkMapView.mapScaleBarPosition = CGPointMake(self.view.frame.size.width - 50, self.view.frame.size.height - 50);
    
    // 定位图层自定义样式参数
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
    displayParam.isRotateAngleValid = NO;//跟随态旋转角度是否生效
    displayParam.isAccuracyCircleShow = NO;//精度圈是否显示
    displayParam.locationViewOffsetX = 0;//定位偏移量(经度)
    displayParam.locationViewOffsetY = 0;//定位偏移量（纬度）
    displayParam.locationViewImgName = @"walk";
    [self.mapView updateLocationViewWithParam:displayParam];
}

#pragma mark - "IBAction" Method

/**
 *  开启百度地图定位服务
 */
- (void)startTrack
{
    // 1.清理上次遗留的轨迹路线以及状态的残留显示
    [self clean];
    
    // 2.打开定位服务
    [self.bmkLocationService startUserLocationService];
    
    //开始计步
    [[StepManager sharedManager] startWithStep];
    [self getStepNumber];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getStepNumber) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    // 3.更新状态栏的“是否打开地理位置服务”的 Label
    self.statusView.startLocatonServiceLabel.text = @"YES";
    self.statusView.stopLocatonServiceLabel.text = @"NO";
    
    // 4.设置当前地图的显示范围，直接显示到用户位置
    //    BMKCoordinateRegion adjustRegion = [self.mapView regionThatFits:BMKCoordinateRegionMake(self.bmkLocationService.userLocation.location.coordinate, BMKCoordinateSpanMake(0.02f,0.02f))];
    //    [self.mapView setRegion:adjustRegion animated:YES];
    
    // 5.如果计时器在计时则复位
    if ([self.statusView.timerLabel counting] || self.statusView.timerLabel.text != nil) {
        [self.statusView.timerLabel reset];
    }
    
    // 6.开始计时
    [self.statusView.timerLabel start];
    
    // 7.设置轨迹记录状态为：开始
    self.trail = TrailStart;
    _shareButton.hidden = YES;
}

/**
 *  停止百度地图定位服务
 */
- (void)stopTrack
{
    // 1.停止计时器
    [self.statusView.timerLabel pause];
    NSLog(@"累计计时为：%@",self.statusView.timerLabel.text);
    [_timer invalidate];
    _timer = nil;
    [[StepManager sharedManager] stopWithStep];
    // 2.更新状态栏的“是否打开地理位置服务”的 Label
    self.statusView.startLocatonServiceLabel.text = @"NO";
    self.statusView.stopLocatonServiceLabel.text = @"YES";
    
    // 3.设置轨迹记录状态为：结束
    self.trail = TrailEnd;
    
    // 4.关闭定位服务
    [self.bmkLocationService stopUserLocationService];
    
    // 5.添加终点旗帜
    if (self.startPoint) {
        self.endPoint = [self creatPointWithLocaiton:self.preLocation title:@"终点"];
    }
    _shareButton.hidden = NO;
    [self cutMapViewAndUplod:_statusView.view];
}

#pragma mark - 截取图片
- (void)cutMapViewAndUplod:(UIView *)theView
{
    //************** 得到图片 *******************
    CGRect rect = theView.frame;  //截取图片大小
    
    //开始取图，参数：截图图片大小
    UIGraphicsBeginImageContext(rect.size);
    //截图层放入上下文中
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    //从上下文中获得图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRef imgRef1 = image.CGImage;
    CGFloat w = CGImageGetWidth(imgRef1);
    CGFloat h = CGImageGetHeight(imgRef1);
    //结束截图
    
    CGImageRef imgRef = [_mapView takeSnapshot].CGImage;
    CGFloat w1= CGImageGetWidth(imgRef);
    CGFloat h1 = CGImageGetHeight(imgRef);
    
    UIGraphicsBeginImageContext(CGSizeMake(w1*0.6, h1*0.5));
    
    [[_mapView takeSnapshot] drawInRect:CGRectMake(0, -70, w1*0.6, h1*0.6)];//先把轨迹画到上下文中
    [image drawInRect:CGRectMake(57, 500, w, h)];//再把小图放在上下文中
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();//从当前上下文中获得最终图片
    UIGraphicsEndImageContext();//关闭上下文

    //[self loadImageFinished:resultImg];
    NSData *imageData =UIImageJPEGRepresentation(resultImg,0.7);
    [self newUploadFileByNSDataBtn:imageData];
   
}

//- (void)loadImageFinished:(UIImage *)image
//{
//    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
//}
//
//- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
//{
//    
//    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
//}


- (void)newUploadFileByNSDataBtn:(NSData*)data{
    NSNumber * distancenum = @([self.statusView.distance.text floatValue]);
    NSNumber * stepnum = @([[self.statusView.step.text stringByReplacingOccurrencesOfString:@"步" withString:@""] integerValue]);
    NSNumber * avgSpeednum = @([[self.statusView.avgSpeed.text stringByReplacingOccurrencesOfString:@"m/s" withString:@""] floatValue]);
//    if([distancenum isEqualToNumber:[NSNumber numberWithInt:0]] || [avgSpeednum isEqualToNumber:[NSNumber numberWithInt:0]]  || [stepnum isEqualToNumber:[NSNumber numberWithInt:0]]){
//        return;
//    }
    BmobFile *file1 = [[BmobFile alloc] initWithFileName:@"image.jpg" withFileData:data];
    [file1 saveInBackground:^(BOOL isSuccessful, NSError *error) {
        //如果文件保存成功，则把文件添加到filetype列
        if (isSuccessful) {
            //UIAlertController风格：UIAlertControllerStyleAlert
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"分享"
                                                                                     message:@"是否将本次运动分享给其他朋友！"
                                                                              preferredStyle:UIAlertControllerStyleAlert ];
            
            //添加取消到UIAlertController中
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                [self addDataWithPlayername:appDelegate.currentUserId WithDistance:distancenum WithStep:stepnum WithAvgSpeed:avgSpeednum WithTime:self.statusView.timerLabel.text WithImgUrl:file1.url WithShare:@"0"];
            }];
            [alertController addAction:cancelAction];
            
            //添加确定到UIAlertController中
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                [self addDataWithPlayername:appDelegate.currentUserId WithDistance:distancenum WithStep:stepnum WithAvgSpeed:avgSpeednum WithTime:self.statusView.timerLabel.text WithImgUrl:file1.url WithShare:@"1"];
            }];
            [alertController addAction:OKAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }else{
            //进行处理
        }
    }];
    //上传文件
}
/**
 把运动数据传入运动表
 
 @param name
 @param distance
 @param step step
 @param avgSpeed
 @param timer
 */
-(void) addDataWithPlayername:(NSString*) name WithDistance:(NSNumber*) distance WithStep:(NSNumber*) step WithAvgSpeed:(NSNumber*) avgSpeed WithTime:(NSString*) timer WithImgUrl:(NSString*) url WithShare:(NSString*) share
{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    BmobObject *SportRecord = [BmobObject objectWithClassName:@"newSportRecord"];
    [SportRecord setObject:name forKey:@"playerName"];
    [SportRecord setObject:distance forKey:@"distance"];
    [SportRecord setObject:step forKey:@"step"];
    [SportRecord setObject:avgSpeed forKey:@"avgSpeed"];
    [SportRecord setObject:timer forKey:@"timer"];
    [SportRecord setObject:url forKey:@"imgurl"];
    [SportRecord setObject:share forKey:@"share"];
    [SportRecord setObject:dateString forKey:@"date"];
    NSLog(@"%@",SportRecord);
    [SportRecord saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        //进行操作
    }];
}

#pragma mark - BMKLocationServiceDelegate
/**
 *  定位失败会调用该方法
 *
 *  @param error 错误信息
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"did failed locate,error is %@",[error localizedDescription]);
    UIAlertView *gpsWeaknessWarning = [[UIAlertView alloc]initWithTitle:@"Positioning Failed" message:@"Please allow to use your Location via Setting->Privacy->Location" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [gpsWeaknessWarning show];
}

/**
 *  用户位置更新后，会调用此函数
 *  @param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    // 1. 动态更新我的位置数据
    [self.mapView updateLocationData:userLocation];
    
    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(self.bmkLocationService.userLocation.location.coordinate, BMKCoordinateSpanMake(0.02f,0.02f));
    BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    [_mapView setRegion:adjustedRegion animated:YES];
    
    NSLog(@"La:%f, Lo:%f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    
    // 2. 更新状态栏的经纬度 Label
    self.statusView.latituteLabel.text = [NSString stringWithFormat:@"%.4f",userLocation.location.coordinate.latitude];
    self.statusView.longtituteLabel.text = [NSString stringWithFormat:@"%.4f",userLocation.location.coordinate.longitude];
    //self.statusView.avgSpeed.text = [NSString stringWithFormat:@"%.2f",userLocation.location.speed];
    
    // 3. 如果精准度不在100米范围内
    if (userLocation.location.horizontalAccuracy > kCLLocationAccuracyNearestTenMeters) {
        NSLog(@"userLocation.location.horizontalAccuracy is %f",userLocation.location.horizontalAccuracy);
        UIAlertView *gpsSignal = [[UIAlertView alloc]initWithTitle:@"GPS提示" message:@"GPS信号弱，运动轨迹起点可能无法标定，或标定不准确！" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [gpsSignal show];
        return;
    }else if (TrailStart == self.trail) { // 开始记录轨迹
        [self startTrailRouteWithUserLocation:userLocation];
    }
}

/**
 *  用户方向更新后，会调用此函数
 *  @param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    // 动态更新我的位置数据
    [self.mapView updateLocationData:userLocation];
}


#pragma mark - Selector for didUpdateBMKUserLocation:
/**
 *  开始记录轨迹
 *
 *  @param userLocation 实时更新的位置信息
 */
- (void)startTrailRouteWithUserLocation:(BMKUserLocation *)userLocation
{
    if (self.preLocation) {
        // 计算本次定位数据与上次定位数据之间的时间差
        NSTimeInterval dtime = [userLocation.location.timestamp timeIntervalSinceDate:self.preLocation.timestamp];
        
        // 累计步行时间
        self.sumTime += dtime;
        self.statusView.sumTime.text = [NSString stringWithFormat:@"%.3f",self.sumTime];
        
        // 计算本次定位数据与上次定位数据之间的距离
        CGFloat distance = [userLocation.location distanceFromLocation:self.preLocation];
        self.statusView.distanceWithPreLoc.text = [NSString stringWithFormat:@"%.2fm",distance];
        NSLog(@"与上一位置点的距离为:%f",distance);
        
        // (5米门限值，存储数组划线) 如果距离少于 5 米，则忽略本次数据直接返回该方法
        if (distance < 5) {
            NSLog(@"与前一更新点距离小于5m，直接返回该方法");
            return;
        }
        
        // 累加步行距离
        self.sumDistance += distance;
        self.statusView.distance.text = [NSString stringWithFormat:@"%.2f",self.sumDistance / 1000.0];
        NSLog(@"步行总距离为:%f",self.sumDistance);
        
        // 计算移动速度
        CGFloat speed = distance / dtime;
        self.statusView.currSpeed.text = [NSString stringWithFormat:@"%.2fm/s",speed];
        
        // 计算平均速度
        CGFloat avgSpeed  =self.sumDistance / self.sumTime;
        self.statusView.avgSpeed.text = [NSString stringWithFormat:@"%.2fm/s",avgSpeed];
    }
    
    // 2. 将符合的位置点存储到数组中
    [self.locationArrayM addObject:userLocation.location];
    self.preLocation = userLocation.location;
    
    // 3. 绘图
    [self drawWalkPolyline];
    
}

/**
 *  绘制步行轨迹路线
 */
- (void)drawWalkPolyline
{
    //轨迹点
    NSUInteger count = self.locationArrayM.count;
    
    // 手动分配存储空间，结构体：地理坐标点，用直角地理坐标表示 X：横坐标 Y：纵坐标
    BMKMapPoint *tempPoints = new BMKMapPoint[count];
    
    [self.locationArrayM enumerateObjectsUsingBlock:^(CLLocation *location, NSUInteger idx, BOOL *stop) {
        BMKMapPoint locationPoint = BMKMapPointForCoordinate(location.coordinate);
        tempPoints[idx] = locationPoint;
        NSLog(@"idx = %ld,tempPoints X = %f Y = %f",idx,tempPoints[idx].x,tempPoints[idx].y);
        
        // 放置起点旗帜
        if (0 == idx && TrailStart == self.trail && self.startPoint == nil) {
            self.startPoint = [self creatPointWithLocaiton:location title:@"起点"];
        }
    }];
    
    //移除原有的绘图
    if (self.polyLine) {
        [self.mapView removeOverlay:self.polyLine];
    }
    
    // 通过points构建BMKPolyline
    self.polyLine = [BMKPolyline polylineWithPoints:tempPoints count:count];
    
    //添加路线,绘图
    if (self.polyLine) {
        [self.mapView addOverlay:self.polyLine];
    }
    
    // 清空 tempPoints 内存
    delete []tempPoints;
    
    [self mapViewFitPolyLine:self.polyLine];
}

/**
 *  添加一个大头针
 *
 *  @param location
 */
- (BMKPointAnnotation *)creatPointWithLocaiton:(CLLocation *)location title:(NSString *)title;
{
    BMKPointAnnotation *point = [[BMKPointAnnotation alloc] init];
    point.coordinate = location.coordinate;
    point.title = title;
    [self.mapView addAnnotation:point];
    
    return point;
}

/**
 *  清空数组以及地图上的轨迹
 */
- (void)clean
{
    // 清空状态栏信息
    self.statusView.step.text = nil;
    self.statusView.distance.text = nil;
    self.statusView.avgSpeed.text = nil;
    self.statusView.currSpeed.text = nil;
    self.statusView.sumTime.text = nil;
    self.statusView.latituteLabel.text = nil;
    self.statusView.longtituteLabel.text = nil;
    self.statusView.distanceWithPreLoc.text = nil;
    self.statusView.startLocatonServiceLabel.text = @"NO";
    self.statusView.stopLocatonServiceLabel.text = @"YES";
    self.statusView.startPointLabel.text = @"NO";
    self.statusView.stopPointLabel.text = @"NO";
    
    //清空数组
    [self.locationArrayM removeAllObjects];
    
    //清屏，移除标注点
    if (self.startPoint) {
        [self.mapView removeAnnotation:self.startPoint];
        self.startPoint = nil;
    }
    if (self.endPoint) {
        [self.mapView removeAnnotation:self.endPoint];
        self.endPoint = nil;
    }
    if (self.polyLine) {
        [self.mapView removeOverlay:self.polyLine];
        self.polyLine = nil;
    }
}

/**
 *  根据polyline设置地图范围
 *
 *  @param polyLine
 */
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [self.mapView setVisibleMapRect:rect];
    self.mapView.zoomLevel = self.mapView.zoomLevel - 0.3;
}


#pragma mark - BMKMapViewDelegate

/**
 *  根据overlay生成对应的View
 *  @param mapView 地图View
 *  @param overlay 指定的overlay
 *  @return 生成的覆盖物View
 */
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor clearColor] colorWithAlphaComponent:0.7];
        polylineView.strokeColor = [[UIColor greenColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 10.0;
        return polylineView;
    }
    return nil;
}

/**
 *  只有在添加大头针的时候会调用，直接在viewDidload中不会调用
 *  根据anntation生成对应的View
 *  @param mapView 地图View
 *  @param annotation 指定的标注
 *  @return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *annotationView = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        if(self.startPoint){ // 有起点旗帜代表应该放置终点旗帜（程序一个循环只放两张旗帜：起点与终点）
            annotationView.pinColor = BMKPinAnnotationColorGreen; // 替换资源包内的图片
            self.statusView.stopPointLabel.text = @"YES";
        }else { // 没有起点旗帜，应放置起点旗帜
            annotationView.pinColor = BMKPinAnnotationColorPurple;
            self.statusView.startPointLabel.text = @"YES";
        }
        
        // 从天上掉下效果
        annotationView.animatesDrop = YES;
        
        // 不可拖拽
        annotationView.draggable = NO;
        
        return annotationView;
    }
    return nil;
}


#pragma mark - lazyLoad

- (NSMutableArray *)locationArrayM
{
    if (_locationArrayM == nil) {
        _locationArrayM = [NSMutableArray array];
    }
    
    return _locationArrayM;
}

@end
