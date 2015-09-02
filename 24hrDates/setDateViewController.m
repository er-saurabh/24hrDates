//
//  setDateViewController.m
//  24hrDates
//
//  Created by Ankit on 07/08/15.
//  Copyright (c) 2015 Ankit. All rights reserved.
//

#import "setDateViewController.h"
#import "KVNProgress.h"
#import "AppDelegate.h"
#import "HomeVC.h"
@interface setDateViewController ()<locationFirebaseDelegate,UITextViewDelegate>
{
    NSString *tempLocHolder,*tempPlaceID;
    Firebase* ref;
    NSDate *toTime;
    NSDate *fromTime;
    NSMutableDictionary *startTimeDict,*endTimeDict;
    NSDate *tempDate;
    
    

}
@end

@implementation setDateViewController
NSString *allday=@"no";
NSString *noteString=@"Grab breakfast before work";
BOOL saveAs=1;


-(NSDate*)convertLocal:(NSDate*)sourceDate
{
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    NSLog(@"%@",[[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate]);
   return [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
  tempDate=[NSDate date];
    toTime=[NSDate date];
    fromTime=[NSDate date];
    startTimeDict=[NSMutableDictionary dictionaryWithObjects:@[tempDate,[tempDate dateByAddingTimeInterval:60*60*44]] forKeys:@[@"min",@"max"]];
    endTimeDict=[NSMutableDictionary dictionaryWithObjects:@[[NSDate date],[tempDate dateByAddingTimeInterval:60*60*3]] forKeys:@[@"min",@"max"]];
    [(UITableView*)[self.view viewWithTag:1]reloadData ];

  // (UITableView*)[[self.view viewWithTag:1] contentInset.UIEdgeInsetsMake(0, 0, 0, 0)];
                    tempLocHolder=@"Choose a location";
    ref = [[Firebase alloc] initWithUrl:@"https://24hrdates.firebaseio.com"];
//    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
//        NSLog(@"%@", snapshot.value);
//    } withCancelBlock:^(NSError *error) {
//        NSLog(@"%@", error.description);
//    }];
//    [ref observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
//        NSLog(@"%@", snapshot.value);
//
//        NSLog(@"%@", snapshot.value[@"NoteForDate"]);
//        descriptionTextView.text=[snapshot.value objectForKey:@"NoteForDate"];
//
//    }];

    // Do any additional setup after loading the view.
    
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=1;

}
- (IBAction)locvcaxn:(id)sender {
    LocationFirebaseViewController *locObj=[self.storyboard instantiateViewControllerWithIdentifier:@"LocationVC"];
    locObj.delegate=self;
    [self.navigationController pushViewController:locObj animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    switch (indexPath.row)
    {
        case 0:
            cell=[tableView dequeueReusableCellWithIdentifier:@"ci1"];
            break;
            
        case 1:
        {
            cell=[tableView dequeueReusableCellWithIdentifier:@"ci2"];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"dd MMMM,yyyy"];
           
            NSLog(@"%@start",[df stringFromDate: [startTimeDict valueForKey:@"min"] ]);
            NSLog(@"%@end",[df stringFromDate: [endTimeDict valueForKey:@"min"]]);

            [(UIButton*)[cell.contentView viewWithTag:21] setTitle:[df stringFromDate: tempDate ] forState:UIControlStateNormal];
            [(UIButton*)[cell.contentView viewWithTag:22] setTitle:[df stringFromDate: [endTimeDict valueForKey:@"min"]]  forState:UIControlStateNormal];
            [df setDateFormat:@"h:mm a"];

            [(UIButton*)[cell.contentView viewWithTag:23] setTitle:[df stringFromDate: tempDate]  forState:UIControlStateNormal];
            [(UIButton*)[cell.contentView viewWithTag:24] setTitle:[df stringFromDate: [endTimeDict valueForKey:@"min"]]  forState:UIControlStateNormal];

            if ([allday isEqualToString:@"yes"])
            {
                [(UIButton*)[cell.contentView viewWithTag:24] setHidden:1];
                [(UIButton*)[cell.contentView viewWithTag:23] setHidden:1];
            }
            else
            {
                [(UIButton*)[cell.contentView viewWithTag:24] setHidden:0];
                [(UIButton*)[cell.contentView viewWithTag:23] setHidden:0];
            }
            

             }

            break;
        case 2:
            cell=[tableView dequeueReusableCellWithIdentifier:@"c5"];
            break;
        case 3:
            cell=[tableView dequeueReusableCellWithIdentifier:@"c4"];
            [(UILabel*)[cell.contentView viewWithTag:15] setText:tempLocHolder];
            descriptionTextView=(UITextView*)[cell.contentView viewWithTag:16];
            break;
        case 4:
            cell=[tableView dequeueReusableCellWithIdentifier:@"ci3"];
            [(UITextView*)[cell.contentView viewWithTag:88]setText:@"Grab Breakfast before work"];
            break;
        
    }

    return cell;
    }
+(NSString*) stringFromDate:(NSDate*) date
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:posix];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"dd MMMM, yyyy"];
    return [dateFormatter stringFromDate:date];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==3) {
        LocationFirebaseViewController *locObj=[self.storyboard instantiateViewControllerWithIdentifier:@"LocationVC"];
        locObj.delegate=self;
        [self.navigationController pushViewController:locObj animated:YES];
}
    }

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    switch (indexPath.row) {
        case 0:
            return 70;
            break;
            
        case 1:
            return 135;
            break;
        case 2:
            return 50;
            break;
        case 3:
            return 70;
            break;
        default:
            return 272;
            break;
}
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(void)returnLocation:(NSString *)locationReturn placeid:(NSString *)placeID
{
    tempLocHolder=locationReturn;
    tempPlaceID=placeID;
    [(UITableView*)[self.view viewWithTag:1]reloadData ];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)cancelButtonEvent:(UIButton *)sender {
     [self.navigationController pushViewController:(HomeVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"] animated:1];
    
}
-(IBAction)saveBtnClick:(UIButton*)sender
{
    
    if ([tempLocHolder isEqualToString:@"Choose a location"])
    {
        UIAlertView *al=[[UIAlertView alloc]initWithTitle:nil message:@"Please enter location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [al show];
    }
    else
    {
        [KVNProgress showWithStatus:@"Saving..."];
        if ([allday isEqualToString:@"nil"])
        {
            allday=@"no";
        }
        if (descriptionTextView.text ==nil)
        {
            descriptionTextView.text=@"na";
        }
       // userRef = [ref childByAppendingPath:[AppHelper userDefaultsForKey:@"id"]];
       // [NSString stringWithFormat:@"%lld",(long long)([selectedDate timeIntervalSince1970] * 1000.0)]
        [self sendOneHrSlotOnFireBase:@{@"fromTime":[NSString stringWithFormat:@"%lld",(long long)([fromTime timeIntervalSince1970] * 1000.0)],@"toTime":[NSString stringWithFormat:@"%lld",(long long)([toTime timeIntervalSince1970] * 1000.0)]}];

    }
}
- (NSInteger)hoursBetween:(NSDate *)firstDate and:(NSDate *)secondDate {
    NSUInteger unitFlags = NSCalendarUnitHour;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:unitFlags fromDate:firstDate toDate:secondDate options:0];
    return [components hour]+1;
}
-(void)sendOneHrSlotOnFireBase:(NSDictionary*)toFromDictionary
{
    NSInteger hourTotal=[self hoursBetween:tempDate and:toTime];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd MMM yyyy-h-aa"];
    NSMutableDictionary* dictProfilefull=[[NSMutableDictionary alloc]init];
    [dictProfilefull setValue:noteString forKey:@"noteForDate"];
    [dictProfilefull setValue:[NSNumber numberWithBool:saveAs] forKey:@"showAs"];
    [dictProfilefull setValue:tempPlaceID forKey:@"placeId"];
    [dictProfilefull setValue:tempLocHolder forKey:@"dateLocation"];
    [dictProfilefull setValue:toFromDictionary forKey:@"freeTime"];
    if ([allday isEqualToString:@"yes"])
    {
        NSLog(@"%f",[[self endOfDay] timeIntervalSinceDate:[NSDate date]]/3600);
        int hourRemaining=([[self endOfDay] timeIntervalSinceDate:[NSDate date]]/3600);
        for (int i=0; i<hourRemaining; i++)
        {
            Firebase *alanRef=[(AppDelegate*)[[UIApplication sharedApplication] delegate]userRef ];
            [dictProfilefull setValue:@{@"fromtime":[NSString stringWithFormat:@"%lld",(long long)([[fromTime dateByAddingTimeInterval:i*60*60] timeIntervalSince1970] * 1000.0)],@"toTime":[NSString stringWithFormat:@"%lld",(long long)([[toTime dateByAddingTimeInterval:i*60*60] timeIntervalSince1970] * 1000.0)]} forKey:@"freeTime"];
            NSString *formattedDate = [[df stringFromDate:[fromTime dateByAddingTimeInterval:i*60*60]] lowercaseString];
            alanRef = [alanRef childByAppendingPath: [NSString stringWithFormat:@"userdata/%@/userFreeTime-%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"FB_ID"],formattedDate ]];
            NSLog(@"%@-----date---%@",[NSString stringWithFormat:@"userdata/%@/userFreeTime-%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"FB_ID"],formattedDate ],[fromTime dateByAddingTimeInterval:i*60*60]);
//            [alanRef setValue:dictProfilefull];
            [alanRef setValue:dictProfilefull withCompletionBlock:^(NSError *error, Firebase *ref) {
                if (i==(hourRemaining-1)) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                    [KVNProgress showSuccess];
                    HomeVC *destViewControllerM=[self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
                    
                    [self.navigationController pushViewController:destViewControllerM animated:YES];
                    });
                }
                

            }];
            
           
        }
        
    }
    else if (hourTotal>1)
    {
        for (int i=0; i<hourTotal; i++)
        {
            NSString *formattedDate = [[df stringFromDate:[fromTime dateByAddingTimeInterval:i*60*60]] lowercaseString];

            Firebase* alanReffff=[(AppDelegate*)[[UIApplication sharedApplication] delegate]userRef ];
           alanReffff = [alanReffff childByAppendingPath: [NSString stringWithFormat:@"userdata/%@/userFreeTime-%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"FB_ID"],formattedDate ]];
            [alanReffff setValue:dictProfilefull];
            NSLog(@"dictProfilefull%@",dictProfilefull);
            if (i==hourTotal-1)
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [KVNProgress showSuccess];
                    
                    HomeVC *destViewControllerM=[self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
                    
                    [self.navigationController pushViewController:destViewControllerM animated:YES];
                });

            }
        }
        
    }
    else
    {
        Firebase *alanReff=[(AppDelegate*)[[UIApplication sharedApplication] delegate]userRef ];

        NSString *formattedDate = [[df stringFromDate:fromTime] lowercaseString];
        alanReff = [alanReff childByAppendingPath: [NSString stringWithFormat:@"userdata/%@/userFreeTime-%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"FB_ID"],formattedDate ]];
        [alanReff setValue:dictProfilefull];
        [KVNProgress showSuccess];
        
        HomeVC *destViewControllerM=[self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
        
        [self.navigationController pushViewController:destViewControllerM animated:YES];
    }
    
    
  
    
    
}
- (IBAction)timeBtnClick:(UIButton *)sender {
    if (sender.tag==23) {
//        NSDateFormatter *df = [[NSDateFormatter alloc] init];
//        [df setDateFormat:@"h:mm a"];
//        NSString *temp= [df stringFromDate:tempDate];
        
        [ActionSheetDatePicker showPickerWithTitle:@"Start Time" datePickerMode:UIDatePickerModeTime selectedDate:tempDate doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin)
         {
             NSDateFormatter *df = [[NSDateFormatter alloc] init];
             [df setDateFormat:@"h:mm a"];
             tempDate=selectedDate;
             [endTimeDict setObject:selectedDate forKey:@"min"];
             [endTimeDict setObject:[selectedDate dateByAddingTimeInterval:60*60*3] forKey:@"max"];
             fromTime=selectedDate;

             NSString *formattedDate = [df stringFromDate:selectedDate];
             [sender setTitle:formattedDate forState:UIControlStateNormal];
             [(UITableView*)[self.view viewWithTag:1]reloadData ];
             
         } cancelBlock:^(ActionSheetDatePicker *picker) {
             
         } origin:self.view slotDictionary:startTimeDict];
    }
    else
    {
        [ActionSheetDatePicker showPickerWithTitle:@"End Time" datePickerMode:UIDatePickerModeTime selectedDate:tempDate doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin)
         {
             NSDateFormatter *df = [[NSDateFormatter alloc] init];
             [df setDateFormat:@"h:mm a"];
             //[df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];

             NSString *formattedDate = [df stringFromDate:selectedDate];
             [sender setTitle:formattedDate forState:UIControlStateNormal];
             toTime=selectedDate;

         } cancelBlock:^(ActionSheetDatePicker *picker) {
             
         } origin:self.view slotDictionary:endTimeDict];
    }
    
}


- (IBAction)fromDateClickEvent:(UIButton *)sender
{
    if (sender.tag==21) {
        [ActionSheetDatePicker showPickerWithTitle:@"Start Date" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin)
         {
             NSDateFormatter *df = [[NSDateFormatter alloc] init];
             [df setDateFormat:@"dd MMMM,yyyy"];
             NSString *formattedDate = [df stringFromDate:selectedDate];
             
             [sender setTitle:formattedDate forState:UIControlStateNormal];
             tempDate=selectedDate;

             [endTimeDict setObject:selectedDate forKey:@"min"];
             [endTimeDict setObject:[selectedDate dateByAddingTimeInterval:60*60*3] forKey:@"max"];
             [(UITableView*)[self.view viewWithTag:1]reloadData ];

             toTime=selectedDate;
         } cancelBlock:^(ActionSheetDatePicker *picker) {
             
         } origin:self.view slotDictionary:[NSDictionary dictionaryWithObjectsAndKeys:[NSDate date],@"min",[[NSDate date] dateByAddingTimeInterval:60*60*44],@"max", nil]];
        
    }
    else if (sender.tag==22)
    {
        [ActionSheetDatePicker showPickerWithTitle:@"End Date" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin)
         {
             NSDateFormatter *df = [[NSDateFormatter alloc] init];
             [df setDateFormat:@"dd MMMM,yyyy"];
             NSString *formattedDate = [df stringFromDate:selectedDate];
            [sender setTitle:formattedDate forState:UIControlStateNormal];
             [(UITableView*)[self.view viewWithTag:1]reloadData ];
             fromTime=selectedDate;
         } cancelBlock:^(ActionSheetDatePicker *picker) {
             
         } origin:self.view slotDictionary:endTimeDict];
    }
    

}
- (IBAction)switchAllDay:(UISwitch *)sender {
    if (sender.isOn) {
        allday=@"yes";

    }
    else
    {
        allday=@"no";

    }
    [(UITableView*)[self.view viewWithTag:1]reloadData ];

    
}
//=======>>>>>>>>>>>text view methods================
-(void)textViewDidChange:(UITextView *)textView
{
    
   
    noteString=textView.text;
//    [(UILabel*)[self.view viewWithTag:99]setText:[NSString stringWithFormat:@"%i",140-textView.text.length]];
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self animateTextField: textView up: NO];


}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self animateTextField: textView up: YES];

    if ([textView.text isEqualToString:@"Grab Breakfast before work"]) {
        textView.text=@"";
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
//    if([text length] == 0)
//    {
//        if([textView.text length] != 0)
//        {
//            return YES;
//        }
//    }
//    else if([[textView text] length] > 139)
//    {
//        return NO;
//    }
    
    return YES;
}
- (void) animateTextField: (UITextView*) textField up: (BOOL) up
{
    const int movementDistance = textField.frame.origin.y+90; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}








//++++++++++++++++++++++
- (IBAction)saveAsEvent:(UIButton *)sender {
    if (sender.tag==56)
    {
        saveAs=1;
        [(UIButton*)[[sender superview] viewWithTag:57]setImage:[UIImage imageNamed:@"grey.png" ] forState:UIControlStateNormal ];
        
    }
    else if (sender.tag==57)
    {
        saveAs=0;
        [(UIButton*)[[sender superview] viewWithTag:56]setImage:[UIImage imageNamed:@"grey.png" ] forState:UIControlStateNormal ];

    }
    [sender setImage:[UIImage imageNamed:@"blue_dot.png" ] forState:UIControlStateNormal];

}
- (IBAction)repeatEvent:(UIButton *)sender {
    RepeatViewController *repeatObject=[self.storyboard instantiateViewControllerWithIdentifier:@"RepeatVC"];
    repeatObject.delegate=self;
    [self.navigationController pushViewController:repeatObject animated:1];
}
-(void)repeatValueReturn:(NSString *)repeat
{
    [(UILabel*)[self.view viewWithTag:77]setText:repeat];
}
- (NSDate *)beginningOfDay
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                               fromDate:[NSDate date]];
    
    return [calendar dateFromComponents:components];
}
- (NSDate *)endOfDay
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [NSDateComponents new];
    components.day = 1;
    
    NSDate *date = [calendar dateByAddingComponents:components
                                             toDate:[self beginningOfDay]
                                            options:0];
    
    date = [date dateByAddingTimeInterval:-1];
    
    return date;
}






   

@end
