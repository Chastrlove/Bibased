//
//  discoverViewController.m
//  运动社交
//
//  Created by Jay on 2017/4/14.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "discoverViewController.h"
#import "JohnTopTitleView.h"
#import "rankViewController.h"
#import "shareViewController.h"
#import "pushViewController.h"

@interface discoverViewController ()

@property (nonatomic,strong) JohnTopTitleView *titleView;

@end
@implementation discoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithRed:245/255 green:245/255 blue:245/255 alpha:1.f];
    self.navigationItem.title = @"动态";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    [self createUI];
    [self.titleView changeToPage:1];
}

- (void)createUI{
    NSArray *titleArray = [NSArray arrayWithObjects:@"排行榜",@"发现",@"推送", nil];
    self.titleView.title = titleArray;
    [self.titleView setupViewControllerWithFatherVC:self childVC:[self setChildVC]];
    [self.view addSubview:self.titleView];
}

- (NSArray <UIViewController *>*)setChildVC{
    rankViewController * vc1 = [[rankViewController alloc]init];
    shareViewController *vc2 = [[shareViewController alloc]init];
    pushViewController *vc3 = [[pushViewController alloc]init];
    NSArray *childVC = [NSArray arrayWithObjects:vc1,vc2,vc3, nil];
    return childVC;
}

#pragma mark - getter
- (JohnTopTitleView *)titleView{
    if (!_titleView) {
    _titleView = [[JohnTopTitleView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    }
    return _titleView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
