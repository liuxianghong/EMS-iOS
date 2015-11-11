//
//  ImageSeeViewController.h
//  ems
//
//  Created by 刘向宏 on 15/11/11.
//  Copyright © 2015年 刘向宏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageSeeViewController : UIViewController
@property (nonatomic,weak) IBOutlet UIImageView *imageView;
@property (nonatomic,strong) IBOutlet NSString *imageName;
@property (nonatomic,strong) IBOutlet UIImage *image;
@end
