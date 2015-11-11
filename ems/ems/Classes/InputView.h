//
//  InputView.h
//  ems
//
//  Created by 刘向宏 on 15/11/11.
//  Copyright © 2015年 刘向宏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputView : UIView
@property (nonatomic,weak) IBOutlet UIView *contentView;
@property (nonatomic,weak) IBOutlet UITextField *field;
@property (nonatomic,weak) IBOutlet UIButton *btn;
@end
