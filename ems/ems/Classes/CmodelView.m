//
//  CmodelView.m
//  ems
//
//  Created by 刘向宏 on 15/12/7.
//  Copyright © 2015年 刘向宏. All rights reserved.
//

#import "CmodelView.h"

@implementation CmodelView

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
    [[NSBundle mainBundle] loadNibNamed:@"ModelView" owner:self options:nil];
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

-(void)setName:(NSString *)name color:(UIColor *)color Seleted:(BOOL)bo
{
    if (self.tag == 2) {
        bo = YES;
        self.labelNameLeft.textColor = [UIColor whiteColor];
        self.labelNameright.textColor = [UIColor whiteColor];
        
        self.labelNameLeft.font = [UIFont systemFontOfSize:24];
        self.labelNameright.font = [UIFont systemFontOfSize:24];
    }
    else
    {
        bo = NO;
    }
    self.labelNameLeft.text = [name substringToIndex:1];
    self.labelNameright.text = [name substringFromIndex:1];
    self.viewClor.backgroundColor = color;
    self.buttonDo.hidden = !bo;
    if (bo) {
        self.leftConstraint.constant = -16;
        self.rightConstraint.constant = 16;
    }
    else
    {
        self.leftConstraint.constant = 0;
        self.rightConstraint.constant = 0;
    }
    self.leftConstraint.constant = 0;
    self.rightConstraint.constant = 0;
    self.buttonDo.hidden = YES;
}

-(IBAction)touchView:(id)sender
{
    if (self.tag == 2) {
        self.leftConstraint.constant = -16;
        self.rightConstraint.constant = 16;
        self.buttonDo.hidden = NO;
    }
}
@end
