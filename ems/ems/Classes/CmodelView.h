//
//  CmodelView.h
//  ems
//
//  Created by 刘向宏 on 15/12/7.
//  Copyright © 2015年 刘向宏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CmodelView : UIView
@property (nonatomic,weak) IBOutlet UIView *contentView;
@property (nonatomic,weak) IBOutlet UILabel *labelNameLeft;
@property (nonatomic,weak) IBOutlet UILabel *labelNameright;
@property (nonatomic,weak) IBOutlet UIView *viewClor;
@property (nonatomic,weak) IBOutlet UIButton *buttonDo;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *leftConstraint;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *rightConstraint;
-(void)setName:(NSString *)name color:(UIColor *)color Seleted:(BOOL)bo;
@end
