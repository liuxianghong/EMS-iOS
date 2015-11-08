//
//  DateScrollView.m
//  ems
//
//  Created by 刘向宏 on 15/11/6.
//  Copyright © 2015年 刘向宏. All rights reserved.
//

#import "DateScrollView.h"
#import "DateView.h"

@interface DateScrollView()<UIScrollViewDelegate>

@end

@implementation DateScrollView
{
    NSMutableArray *labelArray;
    BOOL first;
    
    NSArray *weekArray;
    
    CGPoint currentPoint;
    
    DateView *cView;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    labelArray = [[NSMutableArray alloc]init];
    
    for (int i =0; i<maxDateView; i++) {
        DateView *label = [[DateView alloc]init];
        [self addSubview:label];
        label.tag = i;
        [labelArray addObject:label];
        label.index = i;
    }
    self.pagingEnabled = NO;
    self.delegate = self;
    first = YES;
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (first) {
        NSLog(@"%f",self.width);
        for (DateView *label in labelArray) {
            label.frame = CGRectMake(0+self.width/7*label.tag, 0, self.width/7, self.height);
        }
        DateView *label = labelArray[maxDateView-4];
        cView = label;
        label.current = YES;
        label = labelArray[maxDateView-1];
        self.contentSize = CGSizeMake(label.right, self.height);
        label = labelArray[maxDateView-7];
        currentPoint = self.contentOffset = CGPointMake(label.left, 0);
        first = NO;
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float f = self.contentOffset.x>currentPoint.x?0.5:0.5;
    NSInteger tag = self.contentOffset.x/(self.width/7)+f;
    DateView *view = labelArray[tag+3];
    if (![cView isEqual:view]) {
        cView.current = NO;
        cView = view;
        cView.current = YES;
    }
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    [self doSCroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self doSCroll];
}

-(void)doSCroll{
    float f = self.contentOffset.x>currentPoint.x?0.5:0.5;
    NSInteger tag = self.contentOffset.x/(self.width/7)+f;
    currentPoint = CGPointMake(self.width/7*tag, 0);
    [self setContentOffset:currentPoint animated:YES];
    if (self.dateScrolldelegate) {
        BOOL bo = ((maxDateView-7) == tag);
        [self.dateScrolldelegate didSelectDate:[NSDate date] isToday:bo];
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
