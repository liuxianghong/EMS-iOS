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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
