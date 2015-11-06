//
//  RectView.m
//  ems
//
//  Created by 刘向宏 on 15/11/6.
//  Copyright © 2015年 刘向宏. All rights reserved.
//

#import "RectView.h"

#define PI 3.1415926
@implementation RectView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    /*写文字*/
    CGContextSetRGBFillColor (context,  1, 0, 0, 1.0);//设置填充颜色
    CGContextSetRGBStrokeColor(context,1,1,1,1.0);//画笔线的颜色
    CGContextSetLineWidth(context, 1.0);//线的宽度
    CGContextAddArc(context, rect.size.width/2, rect.size.height/2, rect.size.width/2-2, 0, 2*PI, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathStroke); //绘制路径
    
    CGContextSetLineWidth(context, 3.0);
    CGContextAddArc(context, rect.size.width/2, rect.size.height/2, rect.size.width/2-2, 0, 2*PI*self.power/11.0, 0);
    CGContextDrawPath(context, kCGPathStroke); //绘制路径
//    CGContextAddArc(context, 150, 30, 30, 0, 2*PI, 0); //添加一个圆
//    CGContextDrawPath(context, kCGPathFill);//绘制填充
}

-(void)setPower:(NSInteger)power
{
    _power = power;
    [self setNeedsDisplay];
}

@end
