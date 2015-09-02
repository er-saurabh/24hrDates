//
//  HomeVC.m
//  24hrDates
//
//  Created by Ankit on 05/08/15.
//  Copyright (c) 2015 Ankit. All rights reserved.
//

#import "HomeVC.h"
#import "setDateViewController.h"
#import "MenuVC.h"
#import "HomeCell.h"
#import <Firebase/Firebase.h>
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "KVNProgress.h"
#import "ChatViewController.h"
#import "MeetViewController.h"
static NSString * const kFirebaseURL = @"https://24hrdates.firebaseio.com/";
static NSString * const kGeofireURL = @"https://24hrdates.firebaseio.com/geofire";


@interface HomeVC ()<SwipeableCellDelegate>
{
    Firebase *mFire;
    NSMutableArray *availableKeysGeo;
    int counterAvail,counterIntrested,counterDate;
}
@property (weak, nonatomic) IBOutlet UILabel *totalAvailableLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalInterestedUsers;

@end

@implementation HomeVC
- (IBAction)menuVCEvent:(UIButton *)sender {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];

    MenuVC *menuObject=[self.storyboard instantiateViewControllerWithIdentifier:@"MenuVC"];
    [self.navigationController pushViewController:menuObject animated:0];
    }

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden=1;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
    cell.delegate=self;
    [cell.profilePicView sd_setImageWithURL:[NSURL URLWithString:[[self.availableUsers objectAtIndex:indexPath.row] valueForKey:@"profileImageURL"
                                                                  ]] placeholderImage:[UIImage imageNamed:@"Profile_change.png"]];
    cell.fbID=[[self.availableUsers objectAtIndex:indexPath.row] valueForKey:@"userID"];
    cell.nameHeaderText.text=[NSString stringWithFormat:@"Date With %@",[[self.availableUsers objectAtIndex:indexPath.row] valueForKey:@"firstName"]];
    NSString *locTemp=[[self.availableUsers objectAtIndex:indexPath.row] valueForKey:@"dateLocation"];
    cell.placeLabel.text=locTemp;

    if (locTemp.length>17)
    {
        cell.placeLabel.text=[locTemp substringToIndex:17];

    }
    cell.userfreetime=[[self.availableUsers objectAtIndex:indexPath.row] valueForKey:@"slot"];
    cell.descriptionText.text= [[self.availableUsers objectAtIndex:indexPath.row] valueForKey:@"noteForDate"];
    cell.cellType=[[self.availableUsers objectAtIndex:indexPath.row] valueForKey:@"type"];
    NSArray *stringArray = [[cell.userfreetime substringFromIndex:[cell.userfreetime length]-4] componentsSeparatedByString: @"-"];
    cell.timeSlot.text= [NSString stringWithFormat:@"%@ - %ld%@",[stringArray objectAtIndex:0],[[stringArray objectAtIndex:0]integerValue]+1,[stringArray objectAtIndex:1]];
    cell.hourLabel.text=[stringArray objectAtIndex:0];
    cell.amPmLabel.text=[[stringArray objectAtIndex:1] uppercaseString];
    NSString *temp=[cell.userfreetime substringFromIndex:13];
    temp=[temp substringToIndex:11];
    
        cell.dateLabel.text=[temp uppercaseString];
   // cell.dateLabel.text=
    if ([[[self.availableUsers objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"avail"])
    {
        cell.typeView.backgroundColor=[UIColor redColor];//colorWithRed:245/255 green:20/255 blue:84/255 alpha:1];//F51454  //0000FF
        [cell.rightSideBtn setTitle:@"Meet" forState:UIControlStateNormal];

  
    }
    else if([[[self.availableUsers objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"dateData"])
    {
        cell.typeView.backgroundColor=[UIColor purpleColor];
        [cell.rightSideBtn setTitle:@"Date" forState:UIControlStateNormal];


    }
    else if([[[self.availableUsers objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"interested"])
    {
        cell.typeView.backgroundColor=[UIColor colorWithRed:101/255 green:81/255 blue:255/255 alpha:1];
        [cell.rightSideBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    }

    if ([self.cellsCurrentlyEditing containsObject:indexPath]) {
        [cell openCell];
    }
    return cell;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.availableUsers.count;
}
- (void)viewDidLoad {
    
//    [self.navigationController presentViewController:(setDateViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"setDateVC"] animated:1 completion:^{
//        
//    }];
    [super viewDidLoad];
    
    [KVNProgress showWithStatus:@"Please Wait..."];
    mFire=[[Firebase alloc]initWithUrl:kFirebaseURL];
    self.cellsCurrentlyEditing = [NSMutableSet new];
    self.availableUsers=[[NSMutableArray alloc] init];
    
    // Attach a block to read the data at our posts reference
    //FirebaseHandle handleFetch=
    counterAvail=0;
    counterIntrested=0;
    counterDate=0;
    [mFire observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
       NSLog(@">>>>><<<<<<%@", snapshot.value);
        if (snapshot.value)
        {
            self.userDataResponse=[snapshot.value objectForKey:@"userdata"];
            self.geoLocDataResponse=[snapshot.value objectForKey:@"geofire"];

        }
        Firebase *firebaseGeofire=[(AppDelegate*)[[UIApplication sharedApplication] delegate] userRef];
        firebaseGeofire=[firebaseGeofire childByAppendingPath:[NSString stringWithFormat:@"geofire/"]];
        self.geoObject=[[GeoFire alloc]initWithFirebaseRef:firebaseGeofire];
        CLLocation *locx=[[CLLocation alloc]initWithLatitude:28.57 longitude:77.3200];
        GFCircleQuery *circleQuery = [self.geoObject queryAtLocation:/*[[NSUserDefaults standardUserDefaults]valueForKey:@"login_location"]*/ locx withRadius:50];
        
        // Query location by region
        //    MKCoordinateSpan span = MKCoordinateSpanMake(0.001, 0.001);
        //    MKCoordinateRegion region = MKCoordinateRegionMake([(CLLocation*)[[NSUserDefaults standardUserDefaults]valueForKey:@"login_location"]coordinate ], span);
        //    GFRegionQuery *regionQuery = [self.geoObject queryWithRegion:region];
        availableKeysGeo=[[NSMutableArray alloc] init];
       /* FirebaseHandle queryHandle =*/ [circleQuery observeEventType:GFEventTypeKeyEntered withBlock:^(NSString *key, CLLocation *locationn)
        {
            NSString *fbid=[[NSUserDefaults standardUserDefaults] valueForKey:@"FB_ID"];
            if ([key isEqualToString:@"579579075517906"]) {
                
            }
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"dd MMM yyyy-h-aa"];
            NSString *formattedDate = [[df stringFromDate:[NSDate date]] lowercaseString    ];
            if((![key isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"FB_ID"]]))
            {
                
                
                [self calculateSlots:[_userDataResponse valueForKey:[[NSUserDefaults standardUserDefaults] valueForKey:@"FB_ID"]] :[_userDataResponse valueForKey:key] : fbid : key];
 
               
            }
           if([[_userDataResponse valueForKey:key]valueForKey:@"interested"])
           {
               [self calculateIntrestedData:[_userDataResponse valueForKey:[[NSUserDefaults standardUserDefaults] valueForKey:@"FB_ID"]] :[_userDataResponse valueForKey:key] :fbid :key];
           }
            if([[_userDataResponse valueForKey:key]valueForKey:@"dateData"])
            {
                [self calculateDateData:[_userDataResponse valueForKey:[[NSUserDefaults standardUserDefaults] valueForKey:@"FB_ID"]] :[_userDataResponse valueForKey:key] :fbid :key];
            }
           
            NSLog(@"Key '%@' entered the search area and is at location '%@'", key, locationn);
        }];

    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
    

    
    //self.navigationController.navigationBar.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"available users in your area %@",self.availableUsers);
        self.totalAvailableLabel.text=[NSString stringWithFormat:@"%lu",counterAvail];
        self.totalInterestedUsers.text=[NSString stringWithFormat:@"%lu",counterIntrested];
        self.totalInterestedUsers.text=[NSString stringWithFormat:@"%lu",counterDate];

        [self.tableView reloadData];
        [KVNProgress showSuccess];
        
    });
}
-(void)calculateDateData:(NSDictionary*)mydict :(NSDictionary*)otherDic :(NSString*)myFBID :(NSString*)otherFbID
{
    NSString *fbIdOtherUser=@"";
    NSMutableDictionary *otherrDic=[[NSMutableDictionary alloc] init];
    for (NSString* key in [[otherDic valueForKey:@"dateData"] allKeys])
    {
        fbIdOtherUser=[[mydict valueForKey:@"dateData"]valueForKey:key];
        NSMutableDictionary *tempDict=[[NSMutableDictionary alloc] init];
        [tempDict setObject:[[otherDic valueForKey:@"dateData"] valueForKey:key] forKey:@"userID"];
        otherrDic=[_userDataResponse valueForKey:myFBID];
        for (NSString *basicdata in [[_userDataResponse valueForKey:myFBID] allKeys]) {
            if (![basicdata containsString:@"userFreeTime"])
            {
                [tempDict setObject:[[_userDataResponse valueForKey:myFBID] valueForKey:basicdata] forKey:basicdata];
                
            }
            if([[_userDataResponse valueForKey:otherFbID] valueForKey:basicdata])
            {
                [tempDict setObject:[[_userDataResponse valueForKey:otherFbID] valueForKey:basicdata] forKey:basicdata];

            }
            else
            {
                continue;
            }
            
        }
        for (NSString *temp in [otherrDic allKeys])
        {
            if (![temp containsString:@"userFreeTime"]&&[[_userDataResponse valueForKey:otherFbID] valueForKey:temp])
            {
                [tempDict setObject:[[_userDataResponse valueForKey:otherFbID] valueForKey:temp] forKey:temp];
                [tempDict setValue:@"dateData" forKey:@"type"];
            }
            else
            {
                
                if ([[_userDataResponse valueForKey:otherFbID] valueForKey:temp])
                {
                    [tempDict setObject:[[_userDataResponse valueForKey:otherFbID] valueForKey:temp] forKey:temp];
                    
                }
            }
        }
        [tempDict setObject:key forKey:@"slot"];
//        [tempDict setObject:[[[_userDataResponse valueForKey:otherFbID] valueForKey:key] valueForKey:@"dateLocation"] forKey:@"dateLocation"];
//        [tempDict setObject:[[[_userDataResponse valueForKey:otherFbID] valueForKey:key] valueForKey:@"noteForDate"] forKey:@"noteForDate"];
        counterDate++;
        [self.availableUsers addObject:tempDict];
        
        
        
    }
}

-(void)calculateIntrestedData:(NSDictionary*)mydict :(NSDictionary*)otherDic :(NSString*)myFBID :(NSString*)otherFbID
{
    NSString *fbIdOtherUser=@"";
    NSMutableDictionary *otherrDic=[[NSMutableDictionary alloc] init];
    for (NSString* key in [[mydict valueForKey:@"interested"] allKeys])
    {
        fbIdOtherUser=[[mydict valueForKey:@"interested"]valueForKey:key];
        NSMutableDictionary *tempDict=[[NSMutableDictionary alloc] init];
        [tempDict setObject:[[mydict valueForKey:@"interested"] valueForKey:key] forKey:@"userID"];
        otherrDic=[_userDataResponse valueForKey:myFBID];
        for (NSString *basicdata in [[_userDataResponse valueForKey:myFBID] allKeys]) {
            if (![basicdata containsString:@"userFreeTime"])
            {
                [tempDict setObject:[[_userDataResponse valueForKey:myFBID] valueForKey:basicdata] forKey:basicdata];
  
            }

        }
        for (NSString *temp in [otherrDic allKeys])
        {
            if (![temp containsString:@"userFreeTime"]&&[[_userDataResponse valueForKey:fbIdOtherUser] valueForKey:temp])
            {
                [tempDict setObject:[[_userDataResponse valueForKey:fbIdOtherUser] valueForKey:temp] forKey:temp];
                [tempDict setValue:@"interested" forKey:@"type"];
                counterIntrested++;

            }
            else
            {

                if ([[_userDataResponse valueForKey:fbIdOtherUser] valueForKey:temp])
                {
                    [tempDict setObject:[[_userDataResponse valueForKey:fbIdOtherUser] valueForKey:temp] forKey:temp];

                }
            }
        }
            [tempDict setObject:key forKey:@"slot"];
            [tempDict setObject:[[[_userDataResponse valueForKey:fbIdOtherUser] valueForKey:key] valueForKey:@"dateLocation"] forKey:@"dateLocation"];
                    [tempDict setObject:[[[_userDataResponse valueForKey:fbIdOtherUser] valueForKey:key] valueForKey:@"noteForDate"] forKey:@"noteForDate"];
            [self.availableUsers addObject:tempDict];
        
        
        
    }
}
-(void)calculateSlots:(NSDictionary*)myDict :(NSDictionary*)otherDict :(NSString*)myKey :(NSString*)otherKey
{
    NSMutableArray *myKeyArray=[[NSMutableArray alloc]init ];
    for (NSString *temp in [myDict allKeys])
    {
        
        if ([temp containsString:@"userFreeTime"])
        {
            [myKeyArray addObject:temp];
        }
    }
    NSMutableArray *otherKeyArray=[[NSMutableArray alloc]init ];
    for (NSString *temp in [otherDict allKeys])
    {
        if ([temp containsString:@"userFreeTime"])
        {
            [otherKeyArray addObject:temp];
        }
    }
    NSLog(@"otherKeyArray--%@",otherKeyArray);
    NSLog(@"myKeyArray--%@",myKeyArray);
    for(int i=0;i<myKeyArray.count;i++)
    {
        if ([otherKeyArray containsObject:[myKeyArray objectAtIndex:i]])
        {
            NSMutableDictionary *tempDict=[[NSMutableDictionary alloc] init];
            [tempDict setObject:otherKey forKey:@"userID"];
            [tempDict setValue:@"avail" forKey:@"type"];
            [tempDict setValue:[[_userDataResponse valueForKey:otherKey] valueForKey:@"firstName"] forKey:@"firstName"];
            for (NSString *temp in [otherDict allKeys])
            {
                [tempDict setObject:[[_userDataResponse valueForKey:otherKey] valueForKey:temp] forKey:temp];

                if (![temp containsString:@"userFreeTime"])
                {
                    [tempDict setObject:[[_userDataResponse valueForKey:otherKey] valueForKey:temp] forKey:temp];
                }
                else
                {
                    NSLog(@"%@---key%@",[[[_userDataResponse valueForKey:otherKey] valueForKey:temp] valueForKey:@"showAs"],otherKey);
                    if ([[[[_userDataResponse valueForKey:otherKey] valueForKey:temp] valueForKey:@"showAs"]boolValue]==1) {
                        [tempDict setObject:[NSString stringWithFormat:@"1"] forKey:@"showAs"];
                    }
                    else
                    {
                        [tempDict setObject:[NSString stringWithFormat:@"0"] forKey:@"showAs"];
                        break;

                    }
                }
            }
            [tempDict setObject:[myKeyArray objectAtIndex:i] forKey:@"slot"];
            [tempDict setObject:[[[_userDataResponse valueForKey:otherKey] valueForKey:[myKeyArray objectAtIndex:i]] valueForKey:@"dateLocation"] forKey:@"dateLocation"];
            [tempDict setObject:[[[_userDataResponse valueForKey:otherKey] valueForKey:[myKeyArray objectAtIndex:i]] valueForKey:@"noteForDate"] forKey:@"noteForDate"];

            [self.availableUsers addObject:tempDict];
            counterAvail++;
            //[availableKeysGeo addObject:key];
        }
    }
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ChatViewController *chatObj=[self.storyboard instantiateViewControllerWithIdentifier:@"ChatVC"];
//    [self.navigationController pushViewController:chatObj animated:1];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)buttonClicked:(UIButton *)sender :(HomeCell *)cell
{
    NSLog(@"perform action");
    MeetViewController *meetObj=[self.storyboard instantiateViewControllerWithIdentifier:@"MeetVC"];
    meetObj.cellSource=cell;
    [self.navigationController pushViewController:meetObj animated:1];
    
}
- (IBAction)setDateEvent:(id)sender {
    [self.navigationController pushViewController: (setDateViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"setDateVC"] animated:1 ];
}
- (void)cellDidOpen:(UITableViewCell *)cell {
//    NSIndexPath *currentEditingIndexPath = [self.tableView indexPathForCell:cell];
//    [self.cellsCurrentlyEditing addObject:currentEditingIndexPath];
}

- (void)cellDidClose:(UITableViewCell *)cell {
   // [self.cellsCurrentlyEditing removeObject:[self.tableView indexPathForCell:cell]];
}
@end
