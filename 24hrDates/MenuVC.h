//
//  MenuVC.h
//  24hrDates
//
//  Created by Ankit on 09/08/15.
//  Copyright (c) 2015 Ankit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
- (IBAction)logoutEvent:(id)sender;

@end
