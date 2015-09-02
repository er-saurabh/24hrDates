//
//  MeetViewController.m
//  24hrDates
//
//  Created by Ankit on 31/08/15.
//  Copyright (c) 2015 Ankit. All rights reserved.
//

#import "MeetViewController.h"
#import <Firebase/Firebase.h>
#import "AppDelegate.h"
#import "KVNProgress.h"
@interface MeetViewController ()

@end

@implementation MeetViewController
@synthesize cellSource;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.timeDateLabel.text=[NSString stringWithFormat:@"%@ %@",cellSource.timeSlot.text,cellSource.dateLabel.text];
    self.imageView.image=cellSource.profilePicView.image;
    self.decriptionLabel.text=cellSource.descriptionText.text;
    [[[self.view viewWithTag:999] layer] setBorderColor:[UIColor redColor].CGColor];
    [[[self.view viewWithTag:999] layer]setCornerRadius:5];
    [[[self.view viewWithTag:998] layer]setCornerRadius:5];
    if ([cellSource.cellType isEqualToString:@"avail"])
    {
        [(UIButton*)[self.view viewWithTag:998] setTitle:@"Meet" forState:UIControlStateNormal];
        self.titleLabel.text=[[NSString stringWithFormat:@"%@ is Free to meet",cellSource.nameHeaderText.text] stringByReplacingOccurrencesOfString:@"Date With " withString:@""];

    }
    else if ([cellSource.cellType isEqualToString:@"interested"])
    {
        [(UIButton*)[self.view viewWithTag:998] setTitle:@"Date" forState:UIControlStateNormal];
        self.titleLabel.text=[[NSString stringWithFormat:@"%@ is Free to date",cellSource.nameHeaderText.text] stringByReplacingOccurrencesOfString:@"Date With " withString:@""];


    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:1];
}
- (IBAction)inviteBtnClick:(UIButton *)sender {
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd MMM yyyy-h-aa"];
    NSString *formattedDate = [[df stringFromDate:[NSDate date]] lowercaseString    ];
    [KVNProgress showWithStatus:@"Please wait"];
    Firebase* _ref=[(AppDelegate*)[[UIApplication sharedApplication] delegate] userRef];
    if ([cellSource.cellType isEqualToString:@"avail"])
    {
        _ref=[_ref childByAppendingPath:[NSString stringWithFormat:@"userdata/%@/interested",cellSource.fbID]];
        // userFreeTime-31 aug 2015-5-pm:
        NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
        
        [dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"FB_ID"] forKey:cellSource.userfreetime];
        
        [_ref updateChildValues:dict withCompletionBlock:^(NSError *error, Firebase *ref) {
            Firebase* _reff=[(AppDelegate*)[[UIApplication sharedApplication] delegate] userRef];
            _reff=[_reff childByAppendingPath:[NSString stringWithFormat:@"userdata/%@/%@/showAs",[[NSUserDefaults standardUserDefaults] valueForKey:@"FB_ID"],[NSString stringWithFormat:@"userFreeTime-%@",formattedDate]]];
            [KVNProgress showSuccess];
            [_reff setValue:@"false"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:1];
                
            });
            
            
        }];
    }
    else if ([cellSource.cellType isEqualToString:@"interested"])
    {
        _ref=[_ref childByAppendingPath:[NSString stringWithFormat:@"userdata/%@/dateData",cellSource.fbID]];
        // userFreeTime-31 aug 2015-5-pm:
        NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
        
        [dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"FB_ID"] forKey:cellSource.userfreetime];
        
        [_ref updateChildValues:dict withCompletionBlock:^(NSError *error, Firebase *ref) {
            Firebase* _reff=[(AppDelegate*)[[UIApplication sharedApplication] delegate] userRef];
            _reff=[_reff childByAppendingPath:[NSString stringWithFormat:@"userdata/%@/%@/showAs",[[NSUserDefaults standardUserDefaults] valueForKey:@"FB_ID"],[NSString stringWithFormat:@"userFreeTime-%@",formattedDate]]];
            [KVNProgress showSuccess];
            [_reff setValue:@"false"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:1];
                
            });
            
            
        }];
    }


    
    
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
