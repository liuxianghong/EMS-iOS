//
//  TopView.m
//  ems
//
//  Created by 刘向宏 on 15/11/5.
//  Copyright © 2015年 刘向宏. All rights reserved.
//

#import "TopView.h"

@interface TopView()
@property (nonatomic,weak) IBOutlet UIView *contentView;
@property (nonatomic,weak) IBOutlet UILabel *titleLabel;
@end

@implementation TopView

- (void)awakeFromNib {
    // Initialization code
    [[NSBundle mainBundle] loadNibNamed:@"TopView" owner:self options:nil];
    [self addSubview:self.contentView];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
