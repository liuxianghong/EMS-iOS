//
//  BackGroudViewController.m
//  ems
//
//  Created by 刘向宏 on 15/12/7.
//  Copyright © 2015年 刘向宏. All rights reserved.
//

#import "BackGroudViewController.h"
#import "HJCarouselViewCell.h"
#import "HJCarouselViewLayout.h"

@interface BackGroudViewController ()
@property (nonatomic,weak) IBOutlet UICollectionView *collectionView;
@end

static NSString * const reuseIdentifier = @"Cell";

@implementation BackGroudViewController
{
    NSArray *array;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    HJCarouselViewLayout *layout = [[HJCarouselViewLayout alloc] initWithAnim:HJCarouselAnimLinear];
    //layout.visibleCount = 3;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.collectionViewLayout = layout;
    layout.itemSize = CGSizeMake(self.view.width-80, self.view.height-180);
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HJCarouselViewCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    array = @[@"bg_activity-1.png",@"bg_activity.png"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancelClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSIndexPath *)curIndexPath {
    NSArray *indexPaths = [self.collectionView indexPathsForVisibleItems];
    NSIndexPath *curIndexPath = nil;
    NSInteger curzIndex = 0;
    for (NSIndexPath *path in indexPaths.objectEnumerator) {
        UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:path];
        if (!curIndexPath) {
            curIndexPath = path;
            curzIndex = attributes.zIndex;
            continue;
        }
        if (attributes.zIndex > curzIndex) {
            curIndexPath = path;
            curzIndex = attributes.zIndex;
        }
    }
    return curIndexPath;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *curIndexPath = [self curIndexPath];
    if (indexPath.row == curIndexPath.row) {
        return YES;
    }
    
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
    //    HJCarouselViewLayout *layout = (HJCarouselViewLayout *)collectionView.collectionViewLayout;
    //    CGFloat cellHeight = layout.itemSize.height;
    //    CGRect visibleRect = CGRectZero;
    //    if (indexPath.row > curIndexPath.row) {
    //        visibleRect = CGRectMake(0, cellHeight * indexPath.row + cellHeight / 2, CGRectGetWidth(collectionView.frame), cellHeight / 2);
    //    } else {
    //        visibleRect = CGRectMake(0, cellHeight * indexPath.row, CGRectGetWidth(collectionView.frame), CGRectGetHeight(collectionView.frame));
    //    }
    //    [self.collectionView scrollRectToVisible:visibleRect animated:YES];
    
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"click %ld", indexPath.row);
    NSString *str = array[indexPath.row % 2];
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"viewBG"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HJCarouselViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:array[indexPath.row % 2]];
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
