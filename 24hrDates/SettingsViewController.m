//
//  SettingsViewController.m
//  24hrDates
//
//  Created by Ankit on 20/08/15.
//  Copyright (c) 2015 Ankit. All rights reserved.
//

#import "SettingsViewController.h"
#import "UIImageView+WebCache.h"
#import "KVNProgress.h"
#import <Firebase/Firebase.h>
#import "AppDelegate.h"

@interface SettingsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *name;
    NSString *email;
    NSString *birthday;
    NSString *gender,*interested;

}
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //setting facebook summary
    name=[[NSUserDefaults standardUserDefaults]valueForKey:@"login_name"];
    email=[[NSUserDefaults standardUserDefaults]valueForKey:@"facebookSummary_email"];
    birthday=[[NSUserDefaults standardUserDefaults]valueForKey:@"facebookSummary_birthday"];
    gender=[[NSUserDefaults standardUserDefaults]valueForKey:@"facebookSummary_gender"];

    
    
    
    
    [[(UIImageView*)[self.view viewWithTag:1]layer] setCornerRadius:40];
    [(UIImageView*)[self.view viewWithTag:1] sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=200&height=200",[[NSUserDefaults standardUserDefaults]valueForKey:@"FB_Image"]]] placeholderImage:[UIImage imageNamed:@"Profile_change.png"]];
    [[(UIImageView*)[self.view viewWithTag:3]layer] setCornerRadius:40];
[(UIImageView*)[self.view viewWithTag:3] sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=200&height=200",[[NSUserDefaults standardUserDefaults]valueForKey:@"FB_Image"]]] placeholderImage:[UIImage imageNamed:@"Profile_change.png"]];
    [[(UIImageView*)[self.view viewWithTag:2]layer] setCornerRadius:40];
[(UIImageView*)[self.view viewWithTag:2] sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=200&height=200",[[NSUserDefaults standardUserDefaults]valueForKey:@"FB_Image"]]] placeholderImage:[UIImage imageNamed:@"Profile_change.png"]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    switch (indexPath.row) {
        case 0:
            cell=[tableView dequeueReusableCellWithIdentifier:@"c1"];
            [(UILabel*)[cell.contentView viewWithTag:1]setText:name];
            

            break;
        case 1:
            cell=[tableView dequeueReusableCellWithIdentifier:@"c2"];
            [(UILabel*)[cell.contentView viewWithTag:2]setText:email];

            break;
        case 2:
            cell=[tableView dequeueReusableCellWithIdentifier:@"c3"];
            [(UILabel*)[cell.contentView viewWithTag:3]setText:birthday];

            break;
        case 3:
            cell=[tableView dequeueReusableCellWithIdentifier:@"c4"];
            if ([gender isEqualToString:@"male"]) {
                [(UIButton*)[cell.contentView viewWithTag:34] setImage:[UIImage imageNamed:@"blue_dot.png"] forState:UIControlStateNormal ];
            }
            else{
                [(UIButton*)[cell.contentView viewWithTag:33] setImage:[UIImage imageNamed:@"blue_dot.png"] forState:UIControlStateNormal ];
            }
            break;
        case 4:
            cell=[tableView dequeueReusableCellWithIdentifier:@"c5"];
            
            break;
        default:
            cell=[tableView dequeueReusableCellWithIdentifier:@"c6"];
            
            break;
        
    }
    

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return 70;
            break;
        case 1:
            return 70;
            break;
        case 2:
            return 70;
            break;
        case 3:
            return 70;
            break;
        case 4:
            return 60;
            break;
       
        default:
            return 150;
    }
    //return 1;
    
}
- (IBAction)genderEvent:(UIButton *)sender {
//    if ([gender isEqualToString:@"male"]) {
//         [(UIButton*)[self.view viewWithTag:33] setImage:[UIImage imageNamed:@"green.png"] forState:UIControlStateNormal ];
//    }
//    else{
//        [(UIButton*)[self.view viewWithTag:34] setImage:[UIImage imageNamed:@"green.png"] forState:UIControlStateNormal ];
//    }
//    if (sender.tag==33) {
//        [(UIButton*)[self.view viewWithTag:34] setImage:[UIImage imageNamed:@"grey.png"] forState:UIControlStateNormal ];
//    }
//    else if(sender.tag==34)
//    {
//        [(UIButton*)[self.view viewWithTag:33]setImage:[UIImage imageNamed:@"grey.png"] forState:UIControlStateNormal];
//        
//    }
//    [sender setImage:[UIImage imageNamed:@"green.png"] forState:UIControlStateNormal];
}
- (IBAction)interestedEvent:(UIButton *)sender {
    if (sender.tag==35) {
        interested= @"women";
        [(UIButton*)[self.view viewWithTag:36] setImage:[UIImage imageNamed:@"grey.png"] forState:UIControlStateNormal ];
    }
    else if(sender.tag==36)
    {
        interested= @"men";

        [(UIButton*)[self.view viewWithTag:35]setImage:[UIImage imageNamed:@"grey.png"] forState:UIControlStateNormal];
        
    }
    [sender setImage:[UIImage imageNamed:@"blue_dot.png"] forState:UIControlStateNormal];

}

- (IBAction)cancelEvent:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:1];
}

- (IBAction)saveButtonEvent:(UIButton *)sender {
    [KVNProgress showWithStatus:@"Saving..."];
    
//     Firebase *ref=[(AppDelegate*)[[UIApplication sharedApplication]delegate] userRef];
//     ref=[ref childByAppendingPath:[NSString stringWithFormat:@"userdata/%@/",[[NSUserDefaults standardUserDefaults] valueForKey:@"FB_ID"]]];
//    NSDictionary *dict=[NSDictionary new];
//    [dict setValue:interested forKey:@"interested_in"];
//
//    [ref updateChildValues:dict];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:1];
});
    [KVNProgress showSuccess];
    
}
@end
