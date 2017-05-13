//
//  ViewController2.m
//  TopTitle
//
//  Created by aspilin on 2017/4/11.
//  Copyright © 2017年 aspilin. All rights reserved.
//

#import "shareViewController.h"
#import <BmobSDK/Bmob.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MJRefresh.h>
#import "XWScanImage.h"
#import "shareCell.h"
@interface shareViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _shareTableView;
    NSMutableArray* _data;
    
}

@end

@implementation shareViewController
-(void)viewWillAppear:(BOOL)animated
{
    [_shareTableView.mj_header beginRefreshing];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _shareTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.self.frame.size.height - self.tabBarController.tabBar.frame.size.height - 150) style:UITableViewStylePlain];
    _shareTableView.backgroundColor = [UIColor clearColor];
    _shareTableView.delegate = self;
    _shareTableView.dataSource = self;
    _shareTableView.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:243.0/255.0 alpha:1];
    [_shareTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    _shareTableView.cellLayoutMarginsFollowReadableWidth = NO;
    UIImageView* head = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 230)];
    [head setImage:[UIImage imageNamed:@"shangche.jpg"]];
    //head.backgroundColor = [UIColor yellowColor];
    _shareTableView.tableHeaderView= head;
    //self.navigationController.navigationBar.translucent = NO;
    _shareTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self updateData];
    }];
    [self.view addSubview:_shareTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)updateView
{
    dispatch_async(dispatch_get_main_queue(), ^{[_shareTableView reloadData];;});
    //[self endRefresh];
    
}
-(void)endRefresh{
    [_shareTableView.mj_header endRefreshing];
}
-(void)updateData{
    _data = [[NSMutableArray alloc] init];
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"newSportRecord"];
    bquery.cachePolicy = kBmobCachePolicyNetworkElseCache;
    [bquery whereKey:@"share" equalTo:@"1"];
    [bquery orderByDescending:@"updatedAt"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [obj objectForKey:@"playerName"], @"playerName",
                                 [obj objectForKey:@"imgurl"], @"imgurl",
                                 [obj objectForKey:@"distance"], @"distance",
                                 [obj objectForKey:@"updatedAt"], @"updatedAt",
                                 nil];
            [_data addObject:dic];
        }
        //从网络获取的数据显示在tableViewCell必须要刷新
        NSLog(@"%@",_data);
        [self endRefresh];
        [self performSelectorOnMainThread:@selector(updateView) withObject:nil waitUntilDone:YES];
        //[self updateView];
        
    }];
}
- (NSString *) compareCurrentTime:(NSString *)str
{
    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:str];
    NSDate *currentDate = [NSDate date];
    
    //得到两个时间差
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:timeDate];
    long temp = 0;
    NSString *result;
    if (timeInterval/60 < 1)
    {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    } else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    return  result;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%lu",(unsigned long)_data.count);
    return _data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 253;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CustomCellIdentifier = @"shareCell";
    
    static BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"shareCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CustomCellIdentifier];
        nibsRegistered = YES;
    }
    
    shareCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    if (cell == nil) {
        cell = [[shareCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CustomCellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    NSDictionary *rowData = [_data objectAtIndex:row];
    cell.time.text = [self compareCurrentTime:[rowData objectForKey:@"updatedAt"]];
    cell.name = [rowData objectForKey:@"playerName"];
    cell.iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[rowData objectForKey:@"playerName"]]];
    cell.writeLabel.text =[NSString stringWithFormat:@"今天我完成了%@公里的运动量，感觉整个人快飞起来了！😄",[rowData objectForKey:@"distance"]];
    [cell.ImageView sd_setImageWithURL:[NSURL URLWithString:[rowData objectForKey:@"imgurl"]]
                  placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick1:)];
    [cell.ImageView addGestureRecognizer:tapGestureRecognizer1];
    //让UIImageView和它的父类开启用户交互属性
    [cell.ImageView  setUserInteractionEnabled:YES];
    [cell setSeparatorInset:UIEdgeInsetsZero];//左侧对齐
    cell.selectionStyle = NO;
    return cell;
}
// - 浏览大图点击事件
//为UIImageView1添加点击事件
// - 浏览大图点击事件
-(void)scanBigImageClick1:(UITapGestureRecognizer *)tap{
    NSLog(@"点击图片");
    UIImageView *clickedImageView = (UIImageView *)tap.view;
    [XWScanImage scanBigImageWithImageView:clickedImageView];
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
