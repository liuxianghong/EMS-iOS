//
//  PieView.m
//  ems
//
//  Created by 刘向宏 on 15/11/13.
//  Copyright © 2015年 刘向宏. All rights reserved.
//

#import "PieView.h"

@implementation PieView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    _pie = @[@(0),@(1/3.0),@(2/3.0),@(1)];
}

-(void)setPie:(NSArray *)pie
{
    _pie = pie;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // Draw a white background for the pie chart.
    // We need to do this since many of our color components have alpha < 1.
    
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextAddArc(context, rect.size.width/2, rect.size.height/2, rect.size.width/2-1, 0, 2*M_PI, 1);
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextFillPath(context);
    
    CGContextSaveGState(context);
    
    CGContextBeginTransparencyLayer(context, NULL);
    for (int i = 0; i < 3; ++i) {
        [self drawSlice:i inContext:context Rect:rect];
    }
    CGContextEndTransparencyLayer(context);
    CGContextRestoreGState(context);
}

- (void)drawSlice:(int)index inContext:(CGContextRef)context Rect:(CGRect)rect {
    
    CGFloat startAngle = 2 * M_PI * ([_pie[index] floatValue]);
    CGFloat endAngle = 2 * M_PI * ([_pie[index+1] floatValue]);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL,  rect.size.width/2, rect.size.height/2, rect.size.width/2-1, startAngle, endAngle, 0);
    CGPathAddLineToPoint(path, NULL, rect.size.width/2, rect.size.height/2);
    CGPathCloseSubpath(path);
    
    // Draw the shadowed slice.
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    int TEMP_COLORS[3][3]=
    {
        { 0XE3, 0X30, 0X51},
        { 0X3C, 0X65, 0XB9},
        { 0XFE, 0XFA, 0X53},
    };
    CGContextSetRGBFillColor(context, TEMP_COLORS[index][0]/255.0, TEMP_COLORS[index][1]/255.0, TEMP_COLORS[index][2]/255.0, 1.0);
    CGContextFillPath(context);
    CGContextRestoreGState(context);
    
    // Draw the slice outline.
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextAddPath(context, path);
    CGContextSetLineWidth(context, 0.5);
    UIColor* darken = [UIColor colorWithWhite:0.0 alpha:0.2];
    CGContextSetStrokeColorWithColor(context, darken.CGColor);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    CGPathRelease(path);
}


@end
