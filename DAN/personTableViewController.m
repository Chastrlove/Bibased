//
//  personTableViewController.m
//  运动社交
//
//  Created by Jay on 2017/4/19.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "personTableViewController.h"
#import <BmobSDK/Bmob.h>
#import "loginViewController.h"

#define KScreen_Width [UIScreen mainScreen].bounds.size.width
#define KScreen_Height [UIScreen mainScreen].bounds.size.height


const CGFloat BackGroupHeight = 200;
const CGFloat HeadImageHeight= 100;

@interface personTableViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property(nonatomic,strong) BmobUser *bUser;
@end

@implementation personTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     _bUser = [BmobUser currentUser];
    [self createUI];
}

- (void)createUI{
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    _tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:243.0/255.0 alpha:1];
    _tableView.contentInset = UIEdgeInsetsMake(BackGroupHeight, 0, 0, 0);
    
    [self.view addSubview:_tableView];
    
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    _imageBG = [[UIImageView alloc]init];
    _imageBG.frame = CGRectMake(0, -BackGroupHeight, KScreen_Width, BackGroupHeight);
    _imageBG.image = [UIImage imageNamed:@"back.jpg"];
    
    [_tableView addSubview:_imageBG];
    //
    _BGView = [[UIView alloc]init];
    _BGView.backgroundColor=[UIColor clearColor];
    _BGView.frame=CGRectMake(0, -BackGroupHeight, KScreen_Width, BackGroupHeight);
    
    [_tableView addSubview:_BGView];
    
    //
    _headImageView=[[UIImageView alloc]init];
    _headImageView.image=[UIImage imageNamed:[_bUser objectForKey:@"userId"]];
    _headImageView.frame=CGRectMake((KScreen_Width-HeadImageHeight)/2, 60, HeadImageHeight, HeadImageHeight);
    _headImageView.layer.cornerRadius = HeadImageHeight/2;
    _headImageView.clipsToBounds = YES;
    
    
    [_BGView addSubview:_headImageView];
    
    //
    
    _nameLabel=[[UILabel alloc]init];
    _nameLabel.text=[_bUser objectForKey:@"userId"];
    _nameLabel.textColor=[UIColor whiteColor];
    _nameLabel.textAlignment=NSTextAlignmentCenter;
    _nameLabel.frame=CGRectMake((KScreen_Width-HeadImageHeight)/2, CGRectGetMaxY(_headImageView.frame)+5, HeadImageHeight, 20);
    
    [_BGView addSubview:_nameLabel];
    
    self.navigationItem.title=@"个人中心";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    _rightBtn= [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [_rightBtn setImage:[UIImage imageNamed:@"exit.png"] forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(exitLogin) forControlEvents:UIControlEventTouchUpInside];
    //    [rightBtn setBackgroundImage:[UIImage imageNamed:@"rig"] forState:UIControlStateNormal];
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:_rightBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    
}
-(void)exitLogin{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告"
                                                                             message:@"是否退出登录？"
                                                                      preferredStyle:UIAlertControllerStyleAlert ];
    
    //添加取消到UIAlertController中
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    
    //添加确定到UIAlertController中
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
        NSLog(@"退出登录");
        [BmobUser logout];
        loginViewController *login=[[loginViewController alloc]init];
        [self presentModalViewController:login animated:YES];
    }];
    [alertController addAction:OKAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}
- (void)setTableView:(UITableView *)tableView{
    _tableView = tableView;
}
- (void)setHeadImageView:(UIImageView *)headImageView{
    _headImageView = headImageView;
}
- (void)setNameLabel:(UILabel *)nameLabel{
    _nameLabel = nameLabel;
}
- (void)setImageBG:(UIImageView *)imageBG{
    _imageBG = imageBG;
}

#pragma mark - tableViewDelegate&DataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *reuseIdentifier = @"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//右侧箭头
    if((int)indexPath.row==0){
        cell.textLabel.text = @"账号";
        cell.detailTextLabel.text = _bUser.username;
        //cell.imageView.image = [UIImage imageNamed:@"我们@2x.png"];
        
    }
    if((int)indexPath.row==1){
        cell.textLabel.text = @"性别" ;
        cell.detailTextLabel.text = @"男";
        //cell.imageView.image = [UIImage imageNamed:@"我们@2x.png"];
    }
    if((int)indexPath.row==2){
        cell.textLabel.text = @"个性签名";
        cell.detailTextLabel.text = @"白色的风车，安静的转着！";
        //cell.imageView.image = [UIImage imageNamed:@"我们@2x.png"];
    }
    cell.selectionStyle = NO;
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset  = scrollView.contentOffset.y;
    CGFloat xOffset = (yOffset + BackGroupHeight)/2;
    if (yOffset < -BackGroupHeight) {
        CGRect rect = _imageBG.frame;
        rect.origin.y = yOffset;
        rect.size.height =  -yOffset ;
        rect.origin.x = xOffset;
        rect.size.width = KScreen_Width + fabs(xOffset)*2;
        _imageBG.frame = rect;
        CGRect HeadImageRect = CGRectMake((KScreen_Width-HeadImageHeight)/2, 10, HeadImageHeight, HeadImageHeight);
        HeadImageRect.origin.y = _headImageView.frame.origin.y;
        HeadImageRect.size.height =  HeadImageHeight + fabs(xOffset)*0.1 ;
        HeadImageRect.origin.x = self.view.center.x - HeadImageRect.size.height/2;
        HeadImageRect.size.width = HeadImageHeight + fabs(xOffset)*0.1;
        _headImageView.frame = HeadImageRect;
        _headImageView.layer.cornerRadius = HeadImageRect.size.height/2;
        _headImageView.clipsToBounds = YES;
        
        
    }else{
        CGRect HeadImageRect = CGRectMake((KScreen_Width-HeadImageHeight)/2, 10, HeadImageHeight, HeadImageHeight);
        HeadImageRect.origin.y = _headImageView.frame.origin.y;
        HeadImageRect.size.height =  HeadImageHeight - fabs(xOffset)*0.1 ;
        HeadImageRect.origin.x = self.view.center.x - HeadImageRect.size.height/2;
        HeadImageRect.size.width = HeadImageHeight - fabs(xOffset)*0.1;
        _headImageView.frame = HeadImageRect;
        _headImageView.layer.cornerRadius = HeadImageRect.size.height/2;
        _headImageView.clipsToBounds = YES;
        
        
    }
    CGFloat alpha = 0;
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:[[UIColor clearColor]colorWithAlphaComponent:alpha]] forBarMetrics:UIBarMetricsDefault];
    //    titleLabel.alpha=alpha;
    //    alpha=fabs(alpha);
    //    alpha=fabs(1-alpha);
    //    alpha=alpha<0.2? 0:alpha-0.2;
    //    BGView.alpha=alpha;
    
}


- (UIImage *)imageWithColor:(UIColor *)color
{
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return theImage;
}


@end
