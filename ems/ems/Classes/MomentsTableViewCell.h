//
//  MomentsTableViewCell.h
//  ems
//
//  Created by 刘向宏 on 15/11/11.
//  Copyright © 2015年 刘向宏. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MomentsTableViewCellDelegate<NSObject>
-(void)doComment:(NSDictionary *)dic;
-(void)doImageCick:(NSDictionary *)dic;
-(void)doDeleteCick:(NSDictionary *)dic;
@end

@interface MomentsTableViewCell : UITableViewCell
@property (nonatomic,weak) IBOutlet UIImageView *headImageView;
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *timeLabel;
@property (nonatomic,weak) IBOutlet UILabel *filetitleLabel;
@property (nonatomic,weak) IBOutlet UILabel *contantsLabel;
@property (nonatomic,weak) IBOutlet UIButton *goodbutton;
@property (nonatomic,weak) IBOutlet UIButton *saybutton;
@property (nonatomic,weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic,weak) IBOutlet UILabel *sayLabel;
@property (nonatomic,weak) IBOutlet UIButton *deleteButton;

@property (nonatomic,strong) NSDictionary *dic;

@property (nonatomic,weak) IBOutlet id<MomentsTableViewCellDelegate> delegate;
@end
