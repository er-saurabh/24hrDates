//
//  ViewController.m
//  24hrDates
//
//  Created by Ankit on 05/08/15.
//  Copyright (c) 2015 Ankit. All rights reserved.
//

#import "ViewController.h"
#import "ABCIntroView.h"
#import <Firebase/Firebase.h>
#import <Social/Social.h>
//#import "HomeVC.h"
#import "setDateViewController.h"
#import "FaceBookHelper.h"

#import "KVNProgress.h"
#import "AppDelegate.h"

// The Firebase you want to use for this app
// You must setup Firebase Login for the various authentication providers in the Dashboard under Login & Auth.
static NSString * const kFirebaseURL = @"https://24hrdates.firebaseio.com/";
@interface ViewController ()<ABCIntroViewDelegate>
{
}
@property (nonatomic, strong) Firebase *ref;

@property (weak, nonatomic) IBOutlet ABCIntroView *introView;

@end

@implementation ViewController
@synthesize introView;
- (void)viewDidLoad {
    [super viewDidLoad];
  
    dictForService=[NSMutableDictionary new];
   
    introView.delegate=self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [introView viewSetup];
    });
    
}
-(void)onDoneButtonPressed
{
//    [self.navigationController pushViewController:(setDateViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"setDateVC"] animated:1];
//    return;
    // Adds a status below the circle
    [KVNProgress showWithStatus:@"Logging..."];
    
    // Adds the HUD to a certain view instead of main window
    
    [dictForService removeAllObjects];
    [[FaceBookHelper sharedObject] login:^(id responseData)
    {
        NSLog(@"%@",responseData);

        if(responseData>0)
        {
            if ([responseData objectForKey:@"email"])
            {
                [dictForService setObject:[responseData valueForKey:@"email"] forKey:@"email"];
            }
            else
            {
                [dictForService setObject:@"no mail id" forKey:@"email"];
                
            }
            
            [(AppDelegate*)[[UIApplication sharedApplication]delegate]setUserRef:[[Firebase alloc] initWithUrl:kFirebaseURL]] ;
            
            _ref=[(AppDelegate*)[[UIApplication sharedApplication]delegate] userRef];
            NSString *accessToken = [[FBSDKAccessToken currentAccessToken] tokenString];
            [_ref authWithOAuthProvider:@"facebook" token:accessToken withCompletionBlock:^(NSError *error, FAuthData *authData) {
                if (error) {
                    NSLog(@"Login failed. %@", error);
                 UIAlertView *cAlert = [[UIAlertView alloc] initWithTitle:@"24hr Dates" message:@"Your Facebook account details can't be accessed right now due to private setting. Please try later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [cAlert show];
                    
                    
                }
                else {
                    NSArray *subStrings = [responseData[@"name"] componentsSeparatedByString:@" "];
                                        NSLog(@"Logged in! %@,%@", authData,accessToken);
                    NSLog(@"%@", authData);
                    NSMutableDictionary *dict=[NSMutableDictionary new];
                    //save details
                    [[NSUserDefaults standardUserDefaults]setObject:responseData[@"email"] forKey:@"facebookSummary_email"];[[NSUserDefaults standardUserDefaults]setObject:responseData[@"birthday"] forKey:@"facebookSummary_birthday"];[[NSUserDefaults standardUserDefaults]setObject:responseData[@"gender"] forKey:@"facebookSummary_gender"];
                    [[NSUserDefaults standardUserDefaults]setObject:responseData[@"name"] forKey:@"login_name"];
                    if (responseData[@"email"]) {
                        [dict setObject:responseData[@"email"] forKey:@"email"];
                    }
                    else{
                        [dict setObject:@"Email not Available" forKey:@"email"];
                    }
                    [dict setObject:responseData[@"gender"] forKey:@"gender"];
                    //[dict setObject:responseData[@"id"] forKey:@"id"];
                    [[NSUserDefaults standardUserDefaults]setObject:responseData[@"id"] forKey:@"FB_ID"];
                    [dict setObject:responseData[@"name"] forKey:@"name"];
                    
                    [dict setObject:[subStrings objectAtIndex:0] forKey:@"firstName"];
                    [dict setObject:[subStrings objectAtIndex:1] forKey:@"lastName"];

                    //[dict setObject:[[[responseData valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"] forKey:@"profileImageUrl"];
                    [dict setObject:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=200&height=200",responseData[@"id"]]forKey:@"profileImageURL"];
                    [[NSUserDefaults standardUserDefaults]setObject:responseData[@"id"] forKey:@"FB_Image"];
                   

                    _ref=[_ref childByAppendingPath:[NSString stringWithFormat:@"userdata/%@/",responseData[@"id"]]];
                   


                         [self.ref updateChildValues:dict withCompletionBlock:^(NSError *error, Firebase *ref) {
                             [KVNProgress dismiss];
                           [self.navigationController pushViewController:(setDateViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"setDateVC"] animated:1];
                        
                    }];
                    
                   
                    
                }
            }];
            
            
        }}];
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
