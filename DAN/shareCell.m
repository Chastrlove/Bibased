//
//  shareCell.m
//  运动社交
//
//  Created by Jay on 2017/4/15.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "shareCell.h"

@implementation shareCell
@synthesize iconImageView;
@synthesize nameLabel;
@synthesize writeLabel;
@synthesize ImageView;
@synthesize time;

@synthesize iconImage;
@synthesize name;
@synthesize write;
@synthesize Image;
@synthesize lenowTime;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImage:(UIImage *)img {
    if (![img isEqual:iconImage]) {
        iconImage = [img copy];
        self.iconImageView.image = iconImage;
    }
}

-(void)setName:(NSString *)n {
    if (![n isEqualToString:name]) {
        name = [n copy];
        self.nameLabel.text = name;
    }
}

-(void)setDec:(NSString *)d {
    if (![d isEqualToString:write]) {
        write = [d copy];
        self.writeLabel.text = write;
    }
}

-(void)setLoc:(UIImage *)l {
    if (![l isEqual:Image]) {
        Image = [l copy];
        self.ImageView.image = Image;
    }
}
-(void)setTim:(NSString *)time{
    if (![time isEqualToString:lenowTime]) {
        lenowTime = [time copy];
        self.time.text = lenowTime;
    }
}
@end
