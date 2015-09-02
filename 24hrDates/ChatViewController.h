//
//  ChatViewController.h
//  24hrDates
//
//  Created by Ankit on 21/08/15.
//  Copyright (c) 2015 Ankit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface ChatViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSMutableArray* chat;
@property (nonatomic, strong) Firebase* firebase;

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *nameField;
@end
