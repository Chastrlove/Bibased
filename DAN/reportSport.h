//
//  reportSport.h
//  运动社交
//
//  Created by Jay on 2017/4/18.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface reportSport : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *date;
// 距离
@property (weak, nonatomic) IBOutlet UILabel *distance;

@property (weak, nonatomic) IBOutlet UILabel *week;

@property (weak, nonatomic) IBOutlet UILabel *dayTime;
//步数
//@property (weak, nonatomic) IBOutlet UILabel *step;
// 平均速度
@property (weak, nonatomic) IBOutlet UILabel *avgSpeed;

// 用时
@property (weak, nonatomic) IBOutlet UILabel *useTime;

@end
