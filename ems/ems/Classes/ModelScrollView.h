//
//  ModelScrollView.h
//  ems
//
//  Created by 刘向宏 on 15/12/7.
//  Copyright © 2015年 刘向宏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModelScrollView : UIScrollView
-(void)doLayout;
-(NSInteger)getModel;
@property (nonatomic,strong) UIButton *buttonDO;
@end
