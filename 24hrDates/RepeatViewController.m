//
//  RepeatViewController.m
//  24hrDates
//
//  Created by Ankit on 20/08/15.
//  Copyright (c) 2015 Ankit. All rights reserved.
//

#import "RepeatViewController.h"

@interface RepeatViewController ()

@end

@implementation RepeatViewController
- (IBAction)cancelButtonEvent:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    switch (indexPath.row) {
        case 0:
           
            cell=[tableView dequeueReusableCellWithIdentifier:@"c1"];
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"tick"] isEqualToString:@"never"]) {
                [(UIImageView*)[cell.contentView viewWithTag:1]setImage:[UIImage imageNamed:@"tickb.png"]];
                
            }
            break;
            case 1:
            cell=[tableView dequeueReusableCellWithIdentifier:@"c2"];
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"tick"] isEqualToString:@"everyday"]) {
                [(UIImageView*)[cell.contentView viewWithTag:2]setImage:[UIImage imageNamed:@"tickb.png"]];
                
            }
            break;
        default:
            cell=[tableView dequeueReusableCellWithIdentifier:@"c3"];
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"tick"] isEqualToString:@"every2days"]) {
                [(UIImageView*)[cell.contentView viewWithTag:3]setImage:[UIImage imageNamed:@"tickb.png"]];
                
            }
    }
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @" ";
}
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @" ";
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [[NSUserDefaults standardUserDefaults] setValue:@"never" forKey:@"tick"];
            [self.delegate repeatValueReturn:@"Never"];
            [self.navigationController popViewControllerAnimated:1];
            break;
          case 1:
            [[NSUserDefaults standardUserDefaults] setValue:@"everyday" forKey:@"tick"];

            [self.delegate repeatValueReturn:@"Every Day"];
            [self.navigationController popViewControllerAnimated:1];

            break;
        default:
            [[NSUserDefaults standardUserDefaults] setValue:@"every2days" forKey:@"tick"];

            [self.delegate repeatValueReturn:@"Every 2 Days"];
            [self.navigationController popViewControllerAnimated:1];

            break;
    }
}
@end
