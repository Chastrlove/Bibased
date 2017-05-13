//
//  freindViewController.m
//  运动社交
//
//  Created by Jay on 2017/4/11.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "freindViewController.h"
#import <BmobSDK/Bmob.h>
#import <MJRefresh.h>
#import <RongIMKit/RongIMKit.h>
#import "AppDelegate.h"
@interface freindViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _freindTableView;
    NSMutableArray* _data;

}
@end

@implementation freindViewController
- (void)viewDidAppear:(BOOL)animated{
    self.hidesBottomBarWhenPushed = YES;
}

-(void)viewDidDisappear:(BOOL)animated {
    self.hidesBottomBarWhenPushed = YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [_freindTableView.mj_header beginRefreshing];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 62, 20)] ;
    titleLabel.text = @"运动社交";
    titleLabel.textColor= [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.navigationItem.titleView = titleLabel;
    //[self initData];
    //NSLog(@"读取的数据%@",_data);
    _freindTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _freindTableView.backgroundColor = [UIColor whiteColor];
    _freindTableView.delegate = self;
    _freindTableView.dataSource = self;
    _freindTableView.cellLayoutMarginsFollowReadableWidth = NO;
    [_freindTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.navigationController.navigationBar.translucent = NO;
    _freindTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    [self updateData];
    }];
    [self.view addSubview:_freindTableView];
}

- (void)updateView
{
    [_freindTableView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_freindTableView reloadData];
    });
    //[self endRefresh];
    
}
-(void)endRefresh{
    [_freindTableView.header endRefreshing];
}
/**
 更新通讯录列表
 */
-(void)updateData{
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _data = [[NSMutableArray alloc] init];
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"_User"];
    [bquery whereKey:@"userId" notEqualTo:appDelegate.currentUserId];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [obj objectForKey:@"userId"], @"username",
                                 [obj objectForKey:@"username"], @"userId",
                                 nil];
            [_data addObject:dic];
        }
        //从网络获取的数据显示在tableViewCell必须要刷新
        
        
        [self endRefresh];
        [self performSelectorOnMainThread:@selector(updateView) withObject:nil waitUntilDone:YES];
        //[self updateView];
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    NSDictionary* a = _data[section];
    //    return a.count;
    return _data.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary* sec = _data[indexPath.row];
    //NSLog(@"获取的数据%@",sec);
    static  NSString *CellIdentifier = @ "friendCell" ;
    //自定义cell类
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //   UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    if  (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@ "friendcell"  owner:self options:nil] lastObject];
    }
    _nameLabel.text=[sec objectForKey:@"username"];
    //[_avatarImageView.layer setMasksToBounds:YES];
    //_avatarImageView.layer.cornerRadius=5;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//右侧箭头
    [cell setSeparatorInset:UIEdgeInsetsZero];//左侧对齐
    return cell;
}

/**
 选中cell

 @param tableView <#tableView description#>
 @param indexPath <#indexPath description#>
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RCConversationViewController *vc=[[RCConversationViewController alloc]initWithConversationType:ConversationType_PRIVATE targetId:[_data[indexPath.row] objectForKey:@"userId"]];
    vc.title=[_data[indexPath.row] objectForKey:@"username"];
    [self.navigationController pushViewController:vc animated:YES];
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
