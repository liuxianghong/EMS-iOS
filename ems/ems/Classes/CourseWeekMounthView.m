//
//  CourseWeekMounthView.m
//  ems
//
//  Created by 刘向宏 on 15/11/13.
//  Copyright © 2015年 刘向宏. All rights reserved.
//

#import "CourseWeekMounthView.h"

@interface CourseWeekMounthView()
@property (nonatomic,weak) IBOutlet UIView *contentView;
@property (nonatomic,weak) IBOutlet UILabel *calorieLabel;
@property (nonatomic,weak) IBOutlet UILabel *label1;
@property (nonatomic,weak) IBOutlet UILabel *label2;
@end

@implementation CourseWeekMounthView

- (void)awakeFromNib {
    // Initialization code
    [[NSBundle mainBundle] loadNibNamed:@"CourseWeekMounthView" owner:self options:nil];
    [self addSubview:self.contentView];
    self.backgroundColor = [UIColor clearColor];
}

-(void)setCalorie:(double)calorie
{
    _calorie = calorie;
    if (calorie == 0) {
        self.calorieLabel.text = @"0大卡";
    }
    else
    {
        self.calorieLabel.text = [NSString stringWithFormat:@"%.2f大卡",calorie];
    }
    
}

-(void)setType:(NSInteger)type
{
    _type = type;
    if (type == 1) {
        self.label1.text = @"20h";
        self.label2.text = @"40h";
    }
    self.DataView.type = type;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
}
@end
