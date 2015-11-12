//
//  AttentionTableViewCell.m
//  ems
//
//  Created by 刘向宏 on 15/11/12.
//  Copyright © 2015年 刘向宏. All rights reserved.
//

#import "AttentionTableViewCell.h"

@implementation AttentionTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.headImageView.layer.cornerRadius = 25;
    self.headImageView .layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)addClick:(id)sender
{
    [self.delegate addClick:self.tag];
}

@end
