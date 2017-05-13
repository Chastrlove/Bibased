//
//  ViewController3.m
//  TopTitle
//
//  Created by aspilin on 2017/4/11.
//  Copyright © 2017年 aspilin. All rights reserved.
//

#import "pushViewController.h"
#import "tuisongCell.h"

@interface pushViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _tuiTableView;
    NSMutableArray* _data;
    
}
@end

@implementation pushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _tuiTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.self.frame.size.height - self.tabBarController.tabBar.frame.size.height - 150) style:UITableViewStylePlain];
    _tuiTableView.backgroundColor = [UIColor clearColor];
    _tuiTableView.delegate = self;
    _tuiTableView.dataSource = self;
    _tuiTableView.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:243.0/255.0 alpha:1];
    [_tuiTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    _tuiTableView.cellLayoutMarginsFollowReadableWidth = NO;
//    _tuiTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self updateData];
//    }];
    [self.view addSubview:_tuiTableView];
    
}
-(void) openweb{
    NSURL* url = [[ NSURL alloc ] initWithString :@"http://www.cnys.com/zixun/69477.html"];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 138;
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [self openweb];
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CustomCellIdentifier = @"tuisongCell";
    UIEdgeInsets UIEgde = UIEdgeInsetsMake(0, 10, 0, 10);
    static BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"tuisong" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CustomCellIdentifier];
        nibsRegistered = YES;
    }
    
    tuisongCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    if (cell == nil) {
        cell = [[tuisongCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CustomCellIdentifier];
    }
    cell.ImageView.image = [UIImage imageNamed:@"health3.jpg"];
    [cell setSeparatorInset:UIEgde];//左侧对齐
    cell.selectionStyle = NO;
    return cell;
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
