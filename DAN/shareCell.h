//
//  shareCell.h
//  运动社交
//
//  Created by Jay on 2017/4/15.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface shareCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *writeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) IBOutlet UILabel *time;

@property (copy, nonatomic)  UIImage *iconImage;
@property (copy, nonatomic)  NSString *name;
@property (copy, nonatomic)  NSString *write;
@property (copy, nonatomic)  UIImage *Image;
@property (copy, nonatomic)  NSString *lenowTime;
@end
