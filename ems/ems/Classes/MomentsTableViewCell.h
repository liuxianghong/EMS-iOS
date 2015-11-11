//
//  MomentsTableViewCell.h
//  ems
//
//  Created by 刘向宏 on 15/11/11.
//  Copyright © 2015年 刘向宏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MomentsTableViewCell : UITableViewCell
@property (nonatomic,weak) IBOutlet UIImageView *headImageView;
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *timeLabel;
@property (nonatomic,weak) IBOutlet UILabel *filetitleLabel;
@property (nonatomic,weak) IBOutlet UILabel *contantsLabel;
@property (nonatomic,weak) IBOutlet UIButton *goodbutton;
@property (nonatomic,weak) IBOutlet UIButton *saybutton;
@property (nonatomic,weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSDictionary *dic;
@end
