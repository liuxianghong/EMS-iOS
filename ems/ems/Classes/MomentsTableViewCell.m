//
//  MomentsTableViewCell.m
//  ems
//
//  Created by 刘向宏 on 15/11/11.
//  Copyright © 2015年 刘向宏. All rights reserved.
//

#import "MomentsTableViewCell.h"
#import "MomentsCollectionViewCell.h"
#import <UIImageView+WebCache.h>
#import "EMSAPI.h"

#define MomentsPicWidth ([UIScreen mainScreen].bounds.size.width - 30 - 30)/3

@interface MomentsTableViewCell()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@end

@implementation MomentsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    //self.heightConstraint.constant = 100;
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    CGFloat width = MomentsPicWidth;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",emsresourceURL,dic[@"headimage"]]] placeholderImage:[UIImage imageNamed:@"ic_login_icon.png"]];
    self.nameLabel.text = dic[@"nickname"];
    self.timeLabel.text = dic[@"applytime"];
    self.filetitleLabel.text = dic[@"title"];
    self.contantsLabel.text = dic[@"content"];
    NSArray *images = dic[@"images"];
    if ([images count]==0) {
        self.collectionView.height = self.heightConstraint.constant = 10;
    }
    else
    {
        NSInteger tag = ([images count]+3)/3;
        self.collectionView.height = self.heightConstraint.constant = width*tag;
    }
    NSLog(@"constant:%f",self.heightConstraint.constant);
    [self.collectionView reloadData];
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.dic) {
        NSArray *images = self.dic[@"images"];
        return [images count];
    }
    return 0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"GradientCell";
    MomentsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blackColor];
    NSArray *images = self.dic[@"images"];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",emsresourceURL,images[indexPath.row]]] placeholderImage:nil];//[UIImage imageNamed:@"avator.png"]
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath:%ld",indexPath.row);
}

#pragma mark --UICollectionViewDelegateFlowLayout 

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = MomentsPicWidth;
    return CGSizeMake(width, width);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
@end
