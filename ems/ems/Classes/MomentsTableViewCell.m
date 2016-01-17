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
#import "ImageSeeViewController.h"
#import "EMSAPI.h"

#define MomentsPicWidth ([UIScreen mainScreen].bounds.size.width - 30 - 30)/3

@interface MomentsTableViewCell()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@end

@implementation MomentsTableViewCell
{
    NSInteger good;
    BOOL isGood;
}

- (void)awakeFromNib {
    // Initialization code
    //self.heightConstraint.constant = 100;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iamgeClick:)];
    tapGestureRecognizer.cancelsTouchesInView = YES;
    self.headImageView.userInteractionEnabled = YES;
    [self.headImageView addGestureRecognizer:tapGestureRecognizer];
    
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
    if(!self.goodbutton)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        NSDate *destDate= [dateFormatter dateFromString:dic[@"applytime"]];
        [dateFormatter setDateFormat:@"dd/MM月"];
        self.timeLabel.text = [dateFormatter stringFromDate:destDate];
    }
    else
        self.timeLabel.text = dic[@"applytime"];
    self.filetitleLabel.text = dic[@"title"];
    self.contantsLabel.text = dic[@"content"];
    good = [dic[@"praisecount"]  integerValue];
    [self.goodbutton setTitle:[NSString stringWithFormat:@"👍%ld",(long)good] forState:UIControlStateNormal];
    [self.saybutton setTitle:[NSString stringWithFormat:@"💬%ld",(long)[dic[@"comments"] count]] forState:UIControlStateNormal];
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
    isGood = NO;
    
    NSMutableAttributedString *mstring = [[NSMutableAttributedString alloc]init];
    int i = 0;
    for (NSDictionary *diccomment in dic[@"comments"]) {
        NSString *comment = diccomment[@"comment"];
        NSString *nickname = diccomment[@"nickname"];
        NSString *str = [NSString stringWithFormat:@"%@:%@",nickname,comment];
        if (![diccomment isEqual:[dic[@"comments"] lastObject]]) {
            str = [str stringByAppendingString:@"\n"];
        }
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:str];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:80/255.0 green:95/255.0 blue:150/255.0 alpha:1.0f] range:NSMakeRange(0,[nickname length])];
        [mstring appendAttributedString:string];
        i++;
    }

    self.sayLabel.attributedText = mstring;
}

-(IBAction)goodClick:(id)sender
{
    if (isGood) {
        return;
    }
    isGood = YES;
    NSDictionary *dic = @{
                          @"userid" : [[NSUserDefaults standardUserDefaults] objectForKey:@"id"],
                          @"friends_circle_id" : self.dic[@"id"]
                              
                          };
    [EMSAPI friendsCirclePraiseWithParameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"state"] integerValue] == 0) {
            [self.goodbutton setTitle:[NSString stringWithFormat:@"👍%ld",(long)(--good)] forState:UIControlStateNormal];
        }
        else if ([responseObject[@"state"] integerValue] == 1) {
            [self.goodbutton setTitle:[NSString stringWithFormat:@"👍%ld",(long)(++good)] forState:UIControlStateNormal];
        }
        isGood = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        isGood = NO;
    }];
}

-(IBAction)sayClick:(id)sender
{
    //self.commentView.hidden = NO;
    //[self.commentField becomeFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(doComment:)]) {
        [self.delegate doComment:self.dic];
    }
}

-(IBAction)deleteClick:(id)sender
{
    //self.commentView.hidden = NO;
    //[self.commentField becomeFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(doDeleteCick:)]) {
        [self.delegate doDeleteCick:self.dic];
    }
}

- (UIViewController *)myViewController {
    // Traverse responder chain. Return first found view controller, which will be
    // the view's view controller.
    UIResponder *responder = self;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass:[UIViewController class]])
            return (UIViewController *)responder;
    // If the view controller isn't found, return nil.
    return nil;
}

-(IBAction)iamgeClick:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(doImageCick:)]) {
        [self.delegate doImageCick:self.dic];
    }
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
    NSArray *images = self.dic[@"images"] ;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",emsresourceURL,images[indexPath.row]]] placeholderImage:[UIImage imageNamed:@"black.png"]];//
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath:%ld",indexPath.row);
    NSArray *images = self.dic[@"images"];
    if (images) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Other" bundle:nil];
        ImageSeeViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"seeImage"];
        vc.imageName = images[indexPath.row];
        [[self myViewController] presentViewController:vc animated:NO completion:nil];
    }
    
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
