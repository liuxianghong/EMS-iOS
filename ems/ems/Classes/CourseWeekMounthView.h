//
//  CourseWeekMounthView.h
//  ems
//
//  Created by 刘向宏 on 15/11/13.
//  Copyright © 2015年 刘向宏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateByItemView.h"

@interface CourseWeekMounthView : UIView
@property (nonatomic,weak) IBOutlet DateByItemView *DataView;
@property (nonatomic,assign) double calorie;
@end
