//
//  UserManager.h
//  ems
//
//  Created by 刘向宏 on 15/9/7.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegisterModel : NSObject
@property (nonatomic,strong) NSString *loginname;
@property (nonatomic,strong) NSString *password;
@property (nonatomic,strong) NSString *nickname;

@property (nonatomic,strong) NSString *sex;
@property (nonatomic,strong) NSString *height;
@property (nonatomic,strong) NSString *weight;

@property (nonatomic,strong) NSString *birthDay;
@property (nonatomic,strong) NSString *usertype;
@property (nonatomic,strong) NSString *random;

@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *longitude;
@property (nonatomic,strong) NSString *latitude;
@end

@interface ForgetPWModel : NSObject
@property (nonatomic,strong) NSString *loginname;
@property (nonatomic,strong) NSString *password;
@property (nonatomic,strong) NSString *random;
@end

@interface UserManager : NSObject
+(instancetype)sharedManager;
@property (nonatomic,strong) RegisterModel *registerModel;
@property (nonatomic,strong) ForgetPWModel *forgetPWModel;
@end
