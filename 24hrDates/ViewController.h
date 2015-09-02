//
//  ViewController.h
//  24hrDates
//
//  Created by Ankit on 05/08/15.
//  Copyright (c) 2015 Ankit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
//#import <CoreLocation/CoreLocation.h>
@interface ViewController : UIViewController
{
//    CLLocationManager *locationManager;
//    CLGeocoder *geoCoder;
    NSMutableDictionary *dictForService;

}
@property (nonatomic, strong) ACAccountStore *accountStore;

@end

