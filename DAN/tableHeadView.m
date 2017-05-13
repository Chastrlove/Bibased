//
//  tableHeadView.m
//  运动社交
//
//  Created by Jay on 2017/4/18.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "tableHeadView.h"

@interface tableHeadView ()
/** 渐变背景视图 */
@property (nonatomic, strong) UIView *gradientBackgroundView;
/** 渐变图层 */
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
/** 颜色数组 */
@property (nonatomic, strong) NSMutableArray *gradientLayerColors;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation tableHeadView

- (void)viewDidLoad {
    [super viewDidLoad];
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"runHeadView" owner:self options:nil];
        //得到第一个UIView
    UIView *tmpCustomView = [nib objectAtIndex:0];
    [self.view addSubview:tmpCustomView];
    
    // Do any additional setup after loading the view.
}

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

@end
