//
//  ModelScrollView.m
//  ems
//
//  Created by 刘向宏 on 15/12/7.
//  Copyright © 2015年 刘向宏. All rights reserved.
//

#import "ModelScrollView.h"
#import "CmodelView.h"


@interface ModelScrollView()<UIScrollViewDelegate>

@end

@implementation ModelScrollView
{
    NSMutableArray *labelArray;
    BOOL first;
    
    CGPoint currentPoint;
    
    NSArray *array;
    
    NSInteger currentIndex;
    
    BOOL bo;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    labelArray = [[NSMutableArray alloc]init];
    
    array = @[@[@"瘦身",[UIColor blueColor],@(0x80)],@[@"放松",[UIColor yellowColor],@(0x81)],@[@"塑形",[UIColor redColor],@(0x82)]];
    for (int i =0; i<5; i++) {
        CmodelView *label = [[CmodelView alloc]init];
        [self addSubview:label];
        label.tag = i;
        [labelArray addObject:label];
        NSInteger tt = i%3;
        [label setName:array[tt][0] color:array[tt][1] Seleted:(i==1)];
        if (i==2) {
            self.buttonDO = label.buttonDo;
        }
    }
    bo = NO;
    currentIndex = 0;
    self.delegate = self;
    first = YES;
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (first) {
        [self doLayout];
        first = NO;
    }
}

-(void)doLayout
{
    NSLog(@"%f",self.width);
    for (UIView *label in labelArray) {
        label.frame = CGRectMake(0, 0+self.height/3*label.tag, self.width, self.height/3);
    }
    UIView *label = labelArray.lastObject;
    self.contentSize = CGSizeMake(self.width , label.bottom);
    currentPoint = self.contentOffset = CGPointMake(0, self.contentSize.height/2-self.height/2);
    
}

-(NSInteger)getModel
{
    return currentIndex;
}

-(void)setName{
    for (CmodelView *label in labelArray) {
        NSInteger tt = (label.tag+currentIndex)%3;
        [label setName:array[tt][0] color:array[tt][1] Seleted:NO];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    float f = self.contentOffset.x>currentPoint.x?0.5:0.5;
//    NSInteger tag = self.contentOffset.x/(self.width/7)+f;
//    DateView *view = labelArray[tag+3];
//    if (![cView isEqual:view]) {
//        cView.current = NO;
//        cView = view;
//        cView.current = YES;
//    }
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    [self doSCroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self doSCroll];
}

-(void)doSCroll{
    NSInteger f = self.contentOffset.y>currentPoint.y?1:-1;
    CGFloat ff = ABS(self.contentOffset.y-currentPoint.y);
    CGFloat tag = (ff)/(self.height/3);
    bo = !bo;
    if (tag>0.5 && bo) {
        currentIndex = (currentIndex+6+f)%3;
    }
    NSLog(@"%f %ld",tag,currentIndex);
    currentPoint = CGPointMake(0, self.contentSize.height/2-self.height/2);
    currentPoint = self.contentOffset = CGPointMake(0, self.contentSize.height/2-self.height/2);
    [self setName];
//    if (self.dateScrolldelegate) {
//        BOOL bo = ((maxDateView-7) == tag);
//        NSDate *date2 = [date dateByAddingTimeInterval:24*3600*(tag-(maxDateView-7))];
//        [self.dateScrolldelegate didSelectDate:date2 isToday:bo];
//    }
}
@end