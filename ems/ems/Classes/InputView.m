//
//  InputView.m
//  ems
//
//  Created by 刘向宏 on 15/11/11.
//  Copyright © 2015年 刘向宏. All rights reserved.
//

#import "InputView.h"

@implementation InputView
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self awakeFromNib];
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    [[NSBundle mainBundle] loadNibNamed:@"InputView" owner:self options:nil];
    [self addSubview:self.contentView];
    self.btn.layer.borderWidth = 1;
    self.btn.layer.borderColor = [UIColor blackColor].CGColor;
    self.btn.layer.cornerRadius = 4;
    self.btn.layer.masksToBounds = YES;
    self.layer.borderWidth = 1;///([UIScreen mainScreen].scale);
    self.layer.borderColor = [UIColor lightTextColor].CGColor;
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
