//
//  SettingsViewController.h
//  24hrDates
//
//  Created by Ankit on 20/08/15.
//  Copyright (c) 2015 Ankit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
- (IBAction)cancelEvent:(UIBarButtonItem *)sender;
- (IBAction)saveButtonEvent:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableVIew;

@end
