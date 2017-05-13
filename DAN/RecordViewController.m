//
//  RecordViewController.m
//  xyz
// 入口
//  Created by Jay on 2017/3/30.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "RecordViewController.h"
#import <BmobSDK/Bmob.h>
#import <MJRefresh.h>
#import "AppDelegate.h"
#import "tableHeadView.h"
#import "reportSport.h"
#import "LRSChartView.h"
@interface RecordViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _dataTableView;
    NSMutableArray* _data;
    NSDictionary* _headData;
    NSMutableArray* _sumStepArray;
    NSMutableArray* _dayArray;
}
@property (nonatomic,strong) tableHeadView *headView;
@property (nonatomic, strong) LRSChartView *incomeChartLineView;
/** 渐变背景视图 */
@property (nonatomic, strong) UIView *gradientBackgroundView;
/** 渐变图层 */
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
/** 颜色数组 */
@property (nonatomic, strong) NSMutableArray *gradientLayerColors;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation RecordViewController

-(void)viewDidDisappear:(BOOL)animated {
    self.hidesBottomBarWhenPushed = NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
    [_dataTableView.mj_header beginRefreshing];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCodeButton];
    [self get7day];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 62, 20)] ;
    titleLabel.text = @"运动社交";
    titleLabel.textColor= [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.navigationItem.titleView = titleLabel;
    _dataTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.self.frame.size.height) style:UITableViewStylePlain];
    _dataTableView.backgroundColor = [UIColor whiteColor];
    _dataTableView.delegate = self;
    _dataTableView.dataSource = self;
    _dataTableView.cellLayoutMarginsFollowReadableWidth = NO;
     self.navigationController.navigationBar.translucent = NO;
    self.headView = [[tableHeadView alloc]init];
    _headView.view.frame=CGRectMake(0,0,self.view.frame.size.width,172);
    CALayer *bottomBorder = [CALayer layer];
    float height1=_headView.view.frame.size.height-0.5f;
    float width1=_headView.view.frame.size.width;
    bottomBorder.frame = CGRectMake(0.0f, height1, width1, 0.5f);
    bottomBorder.backgroundColor = [UIColor grayColor].CGColor;
    [_headView.view.layer addSublayer:bottomBorder];
    
    _dataTableView.tableHeaderView=_headView.view;
    _dataTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    [self.view addSubview:_dataTableView];
    
}
-(void) refreshHead{
    _headView.sumCount.text= [NSString stringWithFormat:@"%@",[_headData objectForKey:@"_count"]];
    _headView.sumDistance.text= [NSString stringWithFormat:@"%.2f",[[_headData objectForKey:@"_sumDistance"]doubleValue]];
    _headView.avgStep.text= [NSString stringWithFormat:@"%.1f步",[[_headData objectForKey:@"_avgStep"] doubleValue]];
    _headView.avgSpeed.text= [NSString stringWithFormat:@"%.1fm/s",[[_headData objectForKey:@"_avgAvgSpeed"] doubleValue]];
}
//获取头部运动数据
-(void)getData{
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"newSportRecord"];
    bquery.isGroupcount = YES;
    bquery.cachePolicy = kBmobCachePolicyNetworkElseCache;
    [bquery whereKey:@"playerName" equalTo:appDelegate.currentUserId];
    NSLog(@"头部%@",appDelegate.currentUserId);
    NSArray *sumdisArray = [NSArray arrayWithObject:@"distance"];
    NSArray *avgStepsumArray = [NSArray arrayWithObjects:@"step",@"avgSpeed", nil];
    [bquery sumKeys:sumdisArray];
    [bquery averageKeys:avgStepsumArray];
    [bquery calcInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            NSLog(@"error is:%@",error);
        } else{
            if (array) {
                NSLog(@"%@",array);
                for (NSDictionary *dic in array) {
                    _headData=dic;
                    dispatch_async(dispatch_get_main_queue(), ^{[self refreshHead];});
                }
            }
        }
        _sumStepArray =[[NSMutableArray alloc] init];
        _dayArray =[[NSMutableArray alloc] init];
        BmobQuery *bquery2 = [BmobQuery queryWithClassName:@"newSportRecord"];
        bquery2.cachePolicy = kBmobCachePolicyNetworkElseCache;
        [bquery2 orderByAscending:@"createdAt"];
        [bquery2 whereKey:@"playerName" equalTo:appDelegate.currentUserId];
        NSDictionary *condiction1 = @{@"createdAt":@{@"$gte":@{@"__type": @"Date", @"iso": [self get7day]}}};
        NSDictionary *condiction2 = @{@"createdAt":@{@"$lt":@{@"__type": @"Date", @"iso": [self getnowday]}}};
        NSArray *condictonArray = @[condiction1,condiction2];
        [bquery2 addTheConstraintByAndOperationWithArray:condictonArray];
        NSArray *groupbyArray = [NSArray arrayWithObject:@"date"];
        [bquery2 groupbyKeys:groupbyArray];
        NSArray *StepsumArray = [NSArray arrayWithObjects:@"step", nil];
        [bquery2 sumKeys:StepsumArray];
        [bquery2 calcInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            if (error) {
                NSLog(@"error is:%@",error);
            } else{
                if (array) {
                    NSLog(@"%@",array);
                    for (NSDictionary *dic in array) {
                        [_sumStepArray insertObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"_sumStep"]] atIndex:0];
                        [_dayArray insertObject:[[dic objectForKey:@"date"] substringFromIndex:5] atIndex:0];
                    }
                     dispatch_async(dispatch_get_main_queue(), ^{
                          [_dataTableView reloadData];
                     });
                }
            }
            BmobQuery *bquery1 = [BmobQuery queryWithClassName:@"newSportRecord"];
            _data = [[NSMutableArray alloc] init];
            bquery1.cachePolicy = kBmobCachePolicyNetworkElseCache;
            [bquery1 whereKey:@"playerName" equalTo:appDelegate.currentUserId];
            NSLog(@"TABLE%@",appDelegate.currentUserId);
            [bquery1 orderByDescending:@"updatedAt"];
            [bquery1 findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                for (BmobObject *obj in array) {
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [obj objectForKey:@"playerName"], @"playerName",
                                         [obj objectForKey:@"distance"], @"distance",
                                         [obj objectForKey:@"step"], @"step",
                                         [obj objectForKey:@"avgSpeed"], @"avgSpeed",
                                         [obj objectForKey:@"timer"], @"timer",
                                         [obj updatedAt], @"runtime",
                                         nil];
                    [_data addObject:dic];
                }
                
                [self updateView];
                //从网络获取的数据显示在tableViewCell必须要刷新
            }];
        }];
        
    }];
 
}
-(NSString*) getnowday{
    NSDate *date=[NSDate date];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
    
    dateFormatter.dateFormat=@"YYYY-MM-dd HH:mm:ss";//指定转date得日期格式化形式
    NSLog(@"%@",[dateFormatter stringFromDate:date]);
   return [dateFormatter stringFromDate:date];
}

-(NSString*) get7day{
    NSInteger dis = 7; //前后的天数
    
    NSDate*nowDate = [NSDate date];
    NSDate* theDate;
    NSString *dateString;
    NSString *returnString;
    
    
    if(dis!=0)
    {
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        theDate = [nowDate initWithTimeIntervalSinceNow: -oneDay*dis ];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        dateString = [dateFormatter stringFromDate:theDate];
        returnString = [NSString stringWithFormat:@"%@ 00:00:00",dateString];
    }
    else
    {
        theDate = nowDate;
    }
    return returnString;
}
- (void)updateView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_dataTableView reloadData];
        [self endRefresh];
    });


}
-(void)endRefresh{
    [_dataTableView.mj_header endRefreshing];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 200.0)] ;
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = customView.bounds;
    //设置渐变区域的起始和终止位置（范围为0-1），即渐变路径
    self.gradientLayer.startPoint = CGPointMake(0, 0.0);
    self.gradientLayer.endPoint = CGPointMake(0.7, 0.0);
    //设置颜色的渐变过程
    self.gradientLayerColors = [NSMutableArray arrayWithArray:@[(__bridge id)[UIColor colorWithRed:84 / 255.0 green:179 / 255.0 blue:138 / 255.0 alpha:0.9].CGColor, (__bridge id)[UIColor colorWithRed:74 / 255.0 green:160 / 255.0 blue:154 / 255.0 alpha:0.9].CGColor]];
    self.gradientLayer.colors = self.gradientLayerColors;
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [customView.layer addSublayer:self.gradientLayer];
    if(_dayArray.count==0){
        _sumStepArray=@[@"20",@"30",@"39",@"34",@"74"];
        _dayArray=@[@"2017-04-16",@"2017-04-17",@"2017-04-18",@"2017-04-22",@"2017-04-25"];
    }
    NSArray *tempDataArrOfY = _sumStepArray;
    
    //循环拿到收益最大值
    float tempMax = [tempDataArrOfY[0] floatValue];
    for (int i = 1; i < tempDataArrOfY.count; ++i) {
        if ([tempDataArrOfY[i] floatValue] > tempMax) {
            tempMax = [tempDataArrOfY[i] floatValue];
        }
    }
    
    _incomeChartLineView = [[LRSChartView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    _incomeChartLineView.backgroundColor = [UIColor clearColor];

    _incomeChartLineView.titleOfYStr = @"步数";
    _incomeChartLineView.titleOfXStr = @"(日)";
    _incomeChartLineView.leftDataArr = tempDataArrOfY;
    _incomeChartLineView.dataArrOfY = _sumStepArray;//拿到Y轴坐标
    _incomeChartLineView.dataArrOfX = _dayArray;//拿到X轴坐标
    [customView addSubview:_incomeChartLineView];

    //返回自定义好的效果
    return customView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    NSDictionary* a = _data[section];
    //    return a.count;
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary* sec = _data[indexPath.row];
    NSLog(@"获取的数据%@",sec);
    static  NSString *CellIdentifier = @ "TableViewCell" ;
    //自定义cell类
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    //   UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
//    if  (cell == nil) {
//        //通过xib的名称加载自定义的cell
//        cell = [[[NSBundle mainBundle] loadNibNamed:@ "recordSport"  owner:self options:nil] lastObject];
//    }
    static BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"recordSport" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        nibsRegistered = YES;
    }
    
    reportSport *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[reportSport alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
        cell.date.text=[self changeTime:[sec objectForKey:@"runtime"]];
        cell.distance.text=[NSString stringWithFormat:@"%@公里",[sec objectForKey:@"distance"]];
        cell.avgSpeed.text=[NSString stringWithFormat:@"%@米/秒",[sec objectForKey:@"avgSpeed"]];
        cell.useTime.text=[sec objectForKey:@"timer"];
        cell.week.text=[self calculateWeek:[sec objectForKey:@"runtime"]];
        cell.dayTime.text=[self calculatedateTime:[sec objectForKey:@"runtime"]];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//右侧箭头
    [cell setSeparatorInset:UIEdgeInsetsZero];//左侧对齐
    cell.selectionStyle = NO;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}



/**
 section间距
 
 @param tableView
 @param section
 @return
 */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 200;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initCodeButton
{
    UIButton* chartbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [chartbutton setImage:[UIImage imageNamed:@"runner.png"] forState:UIControlStateNormal];
    [chartbutton addTarget:self action:@selector(chartAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:chartbutton];//为导航栏右侧添加系统自定义按钮
    
}
//导航栏右侧按钮动作
- (void)chartAction
{
    NSLog(@"go");
    NextViewController* scan = [[NextViewController alloc]init];
    //RunViewController* scan = [[RunViewController alloc]init];
    [self.navigationController pushViewController:scan animated:YES];
    
    
}
-(NSString *)calculatedateTime:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH"];
    NSString *currentHourString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    if([currentHourString intValue]<12){
        currentHourString=@"早上跑";
    }else if([currentHourString intValue]<18){
        currentHourString=@"下午跑";
    }else{
        currentHourString=@"晚上跑";
    }
    
    return currentHourString;
}
-(NSString *)changeTime:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd  HH:mm:ss"];
    NSString *changeTime = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    return changeTime;
}

- (NSString *)calculateWeek:(NSDate *)date{
    //计算week数
    NSCalendar * myCalendar = [NSCalendar currentCalendar];
    myCalendar.timeZone = [NSTimeZone systemTimeZone];
    NSInteger week = [[myCalendar components:NSWeekdayCalendarUnit fromDate:date] weekday];
    switch (week) {
        case 1:
        {
            return @"星期日";
        }
        case 2:
        {
            return @"星期一";
        }
        case 3:
        {
            return @"星期二";
        }
        case 4:
        {
            return @"星期三";
        }
        case 5:
        {
            return @"星期四";
        }
        case 6:
        {
            return @"星期五";
        }
        case 7:
        {
            return @"星期六";
        }
    }
    
    return @"";
}
@end


