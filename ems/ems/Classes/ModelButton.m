//
//  ModelButton.m
//  ems
//
//  Created by 刘向宏 on 15/11/7.
//  Copyright © 2015年 刘向宏. All rights reserved.
//

#import "ModelButton.h"

@implementation ModelButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)layoutSubviews
{
    self.layer.cornerRadius = self.frame.size.width/2;
    self.layer.masksToBounds = YES;
}

@end
