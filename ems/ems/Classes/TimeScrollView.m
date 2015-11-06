//
//  TimeScrollView.m
//  ems
//
//  Created by 刘向宏 on 15/11/6.
//  Copyright © 2015年 刘向宏. All rights reserved.
//

#import "TimeScrollView.h"

@implementation TimeScrollView
{
    NSMutableArray *labelArray;
    BOOL first;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    labelArray = [[NSMutableArray alloc]init];
    for (int i =0; i<24; i++) {
        UILabel *label = [[UILabel alloc]init];
        label.textColor = [UIColor whiteColor];
        label.text = [NSString stringWithFormat:@"%d:00",i];
        label.font = [UIFont systemFontOfSize:15];
        [self addSubview:label];
        label.tag = i;
        [label sizeToFit];
        [labelArray addObject:label];
    }
    first = YES;
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (first) {
        NSLog(@"%f",self.width);
        for (UILabel *label in labelArray) {
            label.frame = CGRectMake(0+self.width/4*label.tag, (self.height-label.height)/2, label.width, label.height);
        }
        UILabel *label = labelArray.lastObject;
        self.contentSize = CGSizeMake(label.right, self.height);
        self.contentOffset = CGPointMake(self.contentSize.width/2, 0);
        first = NO;
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
