//
//  CourseTotalView.m
//  ems
//
//  Created by 刘向宏 on 15/11/13.
//  Copyright © 2015年 刘向宏. All rights reserved.
//

#import "CourseTotalView.h"

@interface CourseTotalView()
@property (nonatomic,weak) IBOutlet UIView *contentView;
@end

@implementation CourseTotalView

- (void)awakeFromNib {
    // Initialization code
    [[NSBundle mainBundle] loadNibNamed:@"CourseTotalView" owner:self options:nil];
    [self addSubview:self.contentView];
    self.backgroundColor = [UIColor clearColor];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
}

-(void)setArray:(NSArray *)array
{
    _array = array;
    NSInteger modle1 = [array[0] integerValue];
    NSInteger modle2 = [array[1] integerValue];
    NSInteger modle3 = [array[2] integerValue];
    NSInteger total = modle1+modle2+modle3;
    CGFloat f1 = modle1*1.0/total;
    CGFloat f2 = modle2*1.0/total;
    self.pieView.pie = @[@(0),@(f1),@(f1+f2),@1];
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
