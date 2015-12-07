//
//  DateByItemView.h
//  chartView
//
//  Created by rsaif on 13-10-8.
//  Copyright (c) 2013年 rsaif. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface DateByItemView : UIView
{
    UIView          *lastTapView;
    UILabel         *valueLabel;
    BOOL            selected;
    NSMutableArray  *ItemShowViewArray;
    
    UIScrollView    *contentSV;
    UIView          *contentView;
    
}
@property(nonatomic,retain)NSArray  *dateArray;
@property(nonatomic,retain)NSArray  *ItemArray;
@property(nonatomic,retain)NSArray  *dataArray;
-(void)showDate;
@end
