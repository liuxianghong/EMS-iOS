//
//  DateView.m
//  ems
//
//  Created by 刘向宏 on 15/11/6.
//  Copyright © 2015年 刘向宏. All rights reserved.
//

#import "DateView.h"

@interface DateView()
@property (nonatomic,weak) IBOutlet UIView *contentView;
@property (nonatomic,weak) IBOutlet UILabel *labelWeek;
@property (nonatomic,weak) IBOutlet UILabel *labelDay;
@property (nonatomic,weak) IBOutlet UIView *viewClor;
@end

@implementation DateView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)init
{
    self = [super init];
    [self awakeFromNib];
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    [[NSBundle mainBundle] loadNibNamed:@"DateView" owner:self options:nil];
    [self addSubview:self.contentView];
    
    self.viewClor.layer.cornerRadius = 4;
    self.viewClor.layer.masksToBounds = YES;
    
    self.backgroundColor = self.contentView.backgroundColor = [UIColor clearColor];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
}

-(void)setIndex:(NSInteger)index
{
    _index = index;
    NSDate *date = [NSDate dateWithTimeInterval:(index-(maxDateView - 4))*24*60*60 sinceDate:[NSDate date]];
    NSArray *weekArray = @[@"Sun",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat"];
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSWeekdayCalendarUnit fromDate:date];
    NSInteger weekday = [componets weekday];
    self.labelWeek.text = weekArray[weekday-1];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd"];
    self.labelDay.text = [dateFormat stringFromDate:date];
    if (index == (maxDateView - 4)) {
        self.viewClor.backgroundColor = [UIColor redColor];
    }
    else if (index > (maxDateView - 4)) {
        self.viewClor.backgroundColor = [UIColor lightGrayColor];
    }
}

-(void)setCurrent:(BOOL)current
{
    if (current) {
        self.labelWeek.textColor = [UIColor whiteColor];
        self.labelDay.textColor = [UIColor whiteColor];
    }
    else
    {
        self.labelWeek.textColor = [UIColor darkGrayColor];
        self.labelDay.textColor = [UIColor blackColor];
    }
}

@end
