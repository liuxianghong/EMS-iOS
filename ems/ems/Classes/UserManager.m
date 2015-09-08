//
//  UserManager.m
//  ems
//
//  Created by 刘向宏 on 15/9/7.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "UserManager.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface RegisterModel()<CLLocationManagerDelegate>

@end
@implementation RegisterModel
{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        locationManager = [[CLLocationManager alloc]init];
        locationManager.delegate = self;
        if ([CLLocationManager locationServicesEnabled]) {
            if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [locationManager requestWhenInUseAuthorization];
            } else {
                [locationManager startUpdatingLocation];
            }
        }
        else
            [locationManager startUpdatingLocation];
    }
    return self;
}

#pragma mark - CLLocation Delegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    currentLocation = locations.lastObject;
    [manager stopUpdatingLocation];
    self.latitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
    //------------------位置反编码---5.0之后使用-----------------
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
    {
        if ([placemarks count]>0) {
            CLPlacemark *place = [placemarks objectAtIndex:0];
            self.address = place.name;
            NSLog(@"name,%@",place.name);
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorized) {
        [manager startUpdatingLocation];
        
    }else if(status == kCLAuthorizationStatusDenied){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您没有授权EMS使用您的位置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}
@end

@implementation ForgetPWModel
@end

@implementation UserManager
+(instancetype)sharedManager
{
    static id _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}
@end
