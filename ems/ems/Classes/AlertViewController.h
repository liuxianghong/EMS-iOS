//
//  AlertViewController.h
//  ems
//
//  Created by 刘向宏 on 15/12/7.
//  Copyright © 2015年 刘向宏. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlertViewControllerDelegate <NSObject>
-(void)didClick:(NSInteger)index withTag:(NSInteger)tag;
@end

@interface AlertViewController : UIViewController
@property (nonatomic,weak) id<AlertViewControllerDelegate> delegate;
@property (nonatomic,assign) NSInteger tag;
@end
