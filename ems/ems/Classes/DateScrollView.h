//
//  DateScrollView.h
//  ems
//
//  Created by 刘向宏 on 15/11/6.
//  Copyright © 2015年 刘向宏. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DateScrollViewDelegate <NSObject>
-(void)didSelectDate:(NSDate *)date isToday:(BOOL)bo;
@end

@interface DateScrollView : UIScrollView
@property (nonatomic,weak) IBOutlet id<DateScrollViewDelegate> dateScrolldelegate;
@end
