//
//  tableHeadView.h
//  运动社交
//
//  Created by Jay on 2017/4/18.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tableHeadView : UIViewController
@property (weak, nonatomic) IBOutlet UIView *myView;

@property (weak, nonatomic) IBOutlet UILabel *sumDistance;
//平均步数
@property (weak, nonatomic) IBOutlet UILabel *avgStep;
// 平均速度
@property (weak, nonatomic) IBOutlet UILabel *avgSpeed;
// 总次数
@property (weak, nonatomic) IBOutlet UILabel *sumCount;

@end
