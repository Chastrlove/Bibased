//
//  ViewController1.m
//  TopTitle
//
//  Created by aspilin on 2017/4/11.
//  Copyright © 2017年 aspilin. All rights reserved.
//

#import "rankViewController.h"
#import "rankCell.h"
#import <BmobSDK/Bmob.h>
#import <MJRefresh.h>

@interface rankViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UITableView* _rankTableView;
    NSMutableArray* _data;
    UIView *_headerView;
    UIImageView *_head;
    
}


@end

@implementation rankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self getData];
    _rankTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.self.frame.size.height - self.tabBarController.tabBar.frame.size.height - 150) style:UITableViewStylePlain];
    _rankTableView.backgroundColor = [UIColor clearColor];
    _rankTableView.delegate = self;
    _rankTableView.dataSource = self;
    _rankTableView.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:243.0/255.0 alpha:1];
    [_rankTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    _rankTableView.cellLayoutMarginsFollowReadableWidth = NO;
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 230)];
    _head= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 230)];
    _head.image = [UIImage imageNamed:@"rank.jpg"];
    [_headerView addSubview:_head];
    _rankTableView.tableHeaderView= _headerView;
    [self.view addSubview:_rankTableView];

}
-(void)getData{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"newSportRecord"];
    bquery.isGroupcount = YES;
    bquery.cachePolicy = kBmobCachePolicyNetworkElseCache;
    NSArray *groupbyArray = [NSArray arrayWithObject:@"playerName"];
    [bquery groupbyKeys:groupbyArray];
    NSArray *sumdisArray = [NSArray arrayWithObject:@"distance"];
    [bquery sumKeys:sumdisArray];
    [bquery orderByDescending:@"_sumDistance"];
    [bquery calcInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            NSLog(@"error is:%@",error);
        } else{
            if (array) {
                NSLog(@"%@",array);
                _data =
                [array sortedArrayUsingComparator:^(id obj1,id obj2)
                 {
                     NSDictionary *dic1 = (NSDictionary *)obj1;
                     NSDictionary *dic2 = (NSDictionary *)obj2;
                     NSNumber *num1 = (NSNumber *)[dic1 objectForKey:@"_sumDistance"];
                     NSNumber *num2 = (NSNumber *)[dic2 objectForKey:@"_sumDistance"];
                     if ([num1 floatValue] > [num2 floatValue])
                     {
                         return (NSComparisonResult)NSOrderedAscending;
                     }
                     else
                     {
                         return (NSComparisonResult)NSOrderedDescending;
                     }
                     return (NSComparisonResult)NSOrderedSame;
                 }];
                NSLog(@"%@",_data);
                dispatch_async(dispatch_get_main_queue(), ^{[_rankTableView reloadData];;});
                
            }
        }
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CustomCellIdentifier = @"rankCell";
    
    static BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"rank" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CustomCellIdentifier];
        nibsRegistered = YES;
    }
    
    rankCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    if (cell == nil) {
        cell = [[rankCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CustomCellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    NSDictionary *rowData = [_data objectAtIndex:row];
    cell.order.text = [NSString stringWithFormat:@"%lu",row+1];
    cell.nameLabel.text = [rowData objectForKey:@"playerName"];
    cell.ImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[rowData objectForKey:@"playerName"]]];
    cell.step.text =[NSString stringWithFormat:@"%@",[rowData objectForKey:@"_sumDistance"]];
    [cell setSeparatorInset:UIEdgeInsetsZero];//左侧对齐
    cell.selectionStyle = NO;
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat yOffset = scrollView.contentOffset.y  ;
    
    if (yOffset < 0) {
        CGFloat totalOffset = 230 + ABS(yOffset);
        CGFloat f = totalOffset / 230;
        
        _head.frame = CGRectMake(- (width * f - width) / 2, yOffset, width * f, totalOffset);
        
        
    }
    
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
