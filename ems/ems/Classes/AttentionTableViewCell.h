//
//  AttentionTableViewCell.h
//  ems
//
//  Created by 刘向宏 on 15/11/12.
//  Copyright © 2015年 刘向宏. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AttentionTableViewDelegate <NSObject>
-(void)addClick:(NSInteger)tag;
@end


@interface AttentionTableViewCell : UITableViewCell
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *sexLabel;
@property (nonatomic,weak) IBOutlet UILabel *addressLabel;
@property (nonatomic,weak) IBOutlet UIImageView *headImageView;
@property (nonatomic,weak) IBOutlet id<AttentionTableViewDelegate> delegate;
@end
