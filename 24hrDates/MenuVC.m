//
//  MenuVC.m
//  24hrDates
//
//  Created by Ankit on 09/08/15.
//  Copyright (c) 2015 Ankit. All rights reserved.
//

#import "MenuVC.h"
#import "setDateViewController.h"
#import "UIImageView+WebCache.h"
#import "Branch.h"
#import <MessageUI/MessageUI.h>
#import "KVNProgress.h"
#import <Social/Social.h>
#import "FaceBookHelper.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "SettingsViewController.h"
@interface MenuVC ()<UIAlertViewDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,FBSDKSharingDelegate>
{

}
@property(nonatomic,retain)NSMutableDictionary *monsterMetadata;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation MenuVC
- (IBAction)settingEvent:(UIButton *)sender {
    SettingsViewController *settingObject=[self.storyboard instantiateViewControllerWithIdentifier:@"SettingsVC"];
    [self.navigationController pushViewController:settingObject animated:1];
    
}
- (IBAction)homeVCEvent:(UIButton *)sender {
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:0];

}
- (IBAction)setDAteVCEvent:(UIButton *)sender {
    [self.navigationController pushViewController:(setDateViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"setDateVC"] animated:1];
}

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    //set image
    
    [[(UIImageView*)[self.view viewWithTag:90]layer] setCornerRadius:80];
    [(UIImageView*)[self.view viewWithTag:90] sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=200&height=200",[[NSUserDefaults standardUserDefaults]valueForKey:@"FB_Image"]]] placeholderImage:[UIImage imageNamed:@"Profile_change.png"]];
    
    //set name
    self.nameLabel.text=[[[NSUserDefaults standardUserDefaults]valueForKey:@"login_name"] uppercaseString];
    
    //set location
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"login_location"])
    {
        self.locationLabel.text=[[[NSUserDefaults standardUserDefaults]valueForKey:@"login_location"] uppercaseString];
        
    }
    else
    {
        NSString *locx=@"GPS unavailable";
    self.locationLabel.text=[locx uppercaseString];
    
    }
    //msg
    [[self.messageLabel layer]setCornerRadius:13];
}
-(void)viewWillAppear:(BOOL)animated
{
    //self.navigationController.navigationBarHidden = 1;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)exitMenu:(UIButton*)sender
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:0];

    }

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)logoutEvent:(id)sender {
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Logout" message:@"Are you sure you want to log out?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Yes", nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [[FBSDKLoginManager new] logOut];
        
        [self.navigationController popToRootViewControllerAnimated:1];
    }
}
#pragma mark - Button Actions

- (IBAction)cmdMessageClick:(id)sender {
    // track that the user clicked the share via sms button and pass in the monster meta data
    [[Branch getInstance] userCompletedAction:@"share_sms_click" withState:self.monsterMetadata];
    
    if([MFMessageComposeViewController canSendText])
    {
        [KVNProgress showWithStatus:@"preparing message.."];
        
        MFMessageComposeViewController *smsViewController = [[MFMessageComposeViewController alloc] init];
        smsViewController.messageComposeDelegate = self;
        
        // Create Branch link as soon as the user clicks
        // Pass in the special Branch dictionary of keys/values you want to receive in the AppDelegate on initSession
        // Specify the channel to be 'sms' for tracking on the Branch dashboard
        [[Branch getInstance] getContentUrlWithParams:[NSDictionary dictionaryWithObject:@"http://google.com" forKey:@"AppURL"]  andChannel:@"sms" andCallback:^(NSString *url, NSError *error) {
            [KVNProgress showSuccess];
            // if there was no error, show the SMS View Controller with the Branch deep link
            if (!error) {
                smsViewController.body = [NSString stringWithFormat:@"Check out 24Hr Dates :%@",  url];
                [self presentViewController:smsViewController animated:YES completion:nil];
            }
        }];
    } else {
        UIAlertView *alert_Dialog = [[UIAlertView alloc] initWithTitle:@"No Message Support" message:@"This device does not support messaging" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert_Dialog show];
        alert_Dialog = nil;
    }
    
}

- (IBAction)cmdMailClick:(id)sender {
    // track that the user clicked the share via email button and pass in the monster details
    [[Branch getInstance] userCompletedAction:@"share_email_click" withState:self.monsterMetadata];
    
    if ([MFMailComposeViewController canSendMail]) {
        [KVNProgress showSuccessWithStatus:@"preparing mail.."];
        
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"Check out 24Hrs Date : urlstring"];
        NSArray *toRecipients = nil;
        [mailer setToRecipients:toRecipients];
        
        
        // Create Branch link as soon as the user clicks
        // Pass in the special Branch dictionary of keys/values you want to receive in the AppDelegate on initSession
        // Specify the channel to be 'email' for tracking on the Branch dashboard
        [[Branch getInstance] getContentUrlWithParams:[self prepareFBDict:@"App URl String"]  andChannel:@"email" andCallback:^(NSString *url, NSError *error) {
            
            // if there was no error, show the Email View Controller with the Branch deep link
            if (!error) {
                [KVNProgress showSuccess];

                NSString *emailBody = [NSString stringWithFormat:@"I just created this See it here:\n%@", url];
                [mailer setMessageBody:emailBody isHTML:NO];
                [self presentViewController:mailer animated:YES completion:nil];
            }
            else
            {
                [KVNProgress showError];
            }
        }];
        
    } else {
        UIAlertView *alert_Dialog = [[UIAlertView alloc] initWithTitle:@"No Mail Support" message:@"Your default mail client is not configured" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert_Dialog show];
        alert_Dialog = nil;
    }
}

- (IBAction)cmdTwitterClick:(id)sender {
    // track that user clicked the share on Twitter button and pass in the monster metadata
    [[Branch getInstance] userCompletedAction:@"share_twitter_click" withState:self.monsterMetadata];
    
    SLComposeViewController *twitterController= [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewControllerCompletionHandler completionHandler = ^(SLComposeViewControllerResult result) {
            [twitterController dismissViewControllerAnimated:YES completion:nil];
            switch(result){
                case SLComposeViewControllerResultDone:
                    [[Branch getInstance] userCompletedAction:@"share_twitter_success"];
                    break;
                case SLComposeViewControllerResultCancelled:
                default:
                    break;
            }
        };
        [KVNProgress showWithStatus:@"preparing post.."];
        
        // Create Branch link as soon as the user clicks
        // Pass in the special Branch dictionary of keys/values you want to receive in the AppDelegate on initSession
        // Specify the channel to be 'twitter' for tracking on the Branch dashboard
        [[Branch getInstance] getContentUrlWithParams:[self prepareFBDict:@"app urlstring"]  andChannel:@"twitter" andCallback:^(NSString *url, NSError *error) {
            
            // if there was no error, show the Twitter Share View Controller with the Branch deep link
            if (!error) {
                [KVNProgress showSuccess];
                [twitterController setInitialText:[NSString stringWithFormat:@"Check out my  app %@", url]];
                [twitterController addURL:[NSURL URLWithString:url]];
                [twitterController setCompletionHandler:completionHandler];
                [self presentViewController:twitterController animated:YES completion:nil];
            }
            {
                [KVNProgress showError];
            }
        }];
    } else {
        UIAlertView *alert_Dialog = [[UIAlertView alloc] initWithTitle:@"No Twitter Account" message:@"You do not seem to have Twitter on this device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert_Dialog show];
        alert_Dialog = nil;
    }
}

- (IBAction)cmdFacebookClick:(id)sender {
    // track that user clicked the share button on facebook and pass in the monster metadata
    [[Branch getInstance] userCompletedAction:@"share_facebook_click" withState:self.monsterMetadata];
    [KVNProgress showWithStatus:@"preparing post.."];
    if([FBSDKAccessToken currentAccessToken])
    {
        [self initiateFacebookShare];
  
    }
    else {
        NSLog(@"fb not logged in");
    }

    
}
- (void)initiateFacebookShare {
    
    // Create Branch link as soon as we know there is a valid Facebook session
    // Pass in the special Branch dictionary of keys/values you want to receive in the AppDelegate on initSession
    // Specify the channel to be 'facebook' for tracking on the Branch dashboard
    [[Branch getInstance] getContentUrlWithParams:[self prepareFBDict:@"App Url String"]  andChannel:@"facebook" andCallback:^(NSString *url, NSError *error) {
        
        // If there is no error, do all the fancy foot work to initiate a share on Facebook
        if (!error) {
            [KVNProgress showSuccess];
            FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
            content.contentURL = [NSURL URLWithString:@"http://appsquadz.com/"];
            [FBSDKShareDialog showFromViewController:self withContent:content delegate:self];
//            FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
//            dialog.fromViewController = self;
//            
//            dialog.content = @"Please find my app at : app URL";
//            dialog.mode = FBSDKShareDialogModeShareSheet;
//            [dialog show];
        }
        else
        {
            
        }
    }];
}
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    [[Branch getInstance] userCompletedAction:@"share_facebook_success"];

}
- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    

}

/*!
 @abstract Sent to the delegate when the sharer is cancelled.
 @param sharer The FBSDKSharing that completed.
 */
- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{
    
}

#pragma mark - MFMessageComposeViewControllerProtocol

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    if (MessageComposeResultSent == result) {
        
        // track successful share event via sms
        [[Branch getInstance] userCompletedAction:@"share_sms_success"];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (MFMailComposeResultSent == result) {
        
        // track successful share event via email
        [[Branch getInstance] userCompletedAction:@"share_email_success"];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (NSDictionary *)prepareFBDict:(NSString *)url {
    return [[NSDictionary alloc] initWithObjects:@[
                                                   @"24Hr Dates",
                                                    @"App invitation",
                                                   @"sdbsbfbdsmnb hdbmbasbmba",
                                                   url,
                                                   [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=200&height=200",[[NSUserDefaults standardUserDefaults]valueForKey:@"FB_ID"]]]
                                         forKeys:@[
                                                   @"name",
                                                   @"caption",
                                                   @"description",
                                                   @"link",
                                                   @"picture"]];
}
//- (NSDictionary *)prepareBranchDict {
//    return [[NSDictionary alloc] initWithObjects:@[
//                                                   [NSNumber numberWithInteger:[MonsterPreferences getColorIndex]],
//                                                   [NSNumber numberWithInteger:[MonsterPreferences getBodyIndex]],
//                                                   [NSNumber numberWithInteger:[MonsterPreferences getFaceIndex]],
//                                                   self.monsterName,
//                                                   @"true",
//                                                   [NSString stringWithFormat:@"My Branchster: %@", self.monsterName],
//                                                   self.monsterDescription,
//                                                   [NSString stringWithFormat:@"https://s3-us-west-1.amazonaws.com/branchmonsterfactory/%hd%hd%hd.png", (short)[MonsterPreferences getColorIndex], (short)[MonsterPreferences getBodyIndex], (short)[MonsterPreferences getFaceIndex]]]
//                                         forKeys:@[
//                                                   @"color_index",
//                                                   @"body_index",
//                                                   @"face_index",
//                                                   @"monster_name",
//                                                   @"monster",
//                                                   @"$og_title",
//                                                   @"$og_description",
//                                                   @"$og_image_url"]];
//}

@end
