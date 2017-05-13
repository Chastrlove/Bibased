//
//  textFieldBackground.m
//  运动社交
//
//  Created by Jay on 2017/4/18.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "textFieldBackground.h"

@implementation textFieldBackground

- (void)drawRect:(CGRect)rect {
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context,0.2);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 5, 50);
    CGContextAddLineToPoint(context,self.frame.size.width-5, 50);
    CGContextClosePath(context);
    [[UIColor grayColor] setStroke];
    CGContextStrokePath(context);
}

@end
