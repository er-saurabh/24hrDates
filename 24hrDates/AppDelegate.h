//
//  AppDelegate.h
//  24hrDates
//
//  Created by Ankit on 05/08/15.
//  Copyright (c) 2015 Ankit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>
//sync
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic)Firebase *userRef;

@end

