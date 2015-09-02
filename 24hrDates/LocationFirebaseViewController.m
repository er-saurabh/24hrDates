//
//  LocationFirebaseViewController.m
//  24hr Dates
//
//  Created by Ankit
//  Copyright (c) 2015 Fourth Screen Labs Pvt Ltd. All rights reserved.
//

#import "LocationFirebaseViewController.h"
#import "AppDelegate.h"
#import "setDateViewController.h"
#import <Firebase/Firebase.h>
#import "AppDelegate.h"
//#import "LOGINVC.h"
static NSString * const kFirebaseURL = @"https://24hrdates.firebaseio.com/geofire";
@interface LocationFirebaseViewController ()<UIScrollViewDelegate>
{
}
@property(nonatomic,retain)    Firebase *locNode;

@end

@implementation LocationFirebaseViewController
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [(UISearchBar*)[self.view viewWithTag:14] resignFirstResponder];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)activeScrollView {
    
    [(UISearchBar*)[self.view viewWithTag:14] resignFirstResponder];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [(UISearchBar*)[self.view viewWithTag:14] becomeFirstResponder];

    _locNode=[(AppDelegate*)[[UIApplication sharedApplication] delegate] userRef] ;
    _locNode=[_locNode childByAppendingPath:[NSString stringWithFormat:@"geofire/"]];
    loc=[CLLocationManager new];
    self.address=[NSMutableArray new];
    self.placeId=[NSMutableArray new];
//    [loc requestWhenInUseAuthorization];
//    [loc requestAlwaysAuthorization];
    [loc startUpdatingLocation];
    
   _geoObject = [[GeoFire alloc] initWithFirebaseRef:_locNode];
    //[loction setValue:[[CLLocation alloc] initWithLatitude:
//     location.coordinate.latitude longitude:location.coordinate.longitude
//     ] forKey:[[NSUserDefaults standardUserDefaults]valueForKey:@"FB_ID"]];

    CLLocation *LocationAtual = [[CLLocation alloc] initWithLatitude:loc.location.coordinate.latitude  longitude:loc.location.coordinate.longitude];

    
    [_geoObject setLocation:LocationAtual
                     forKey:[[NSUserDefaults standardUserDefaults]valueForKey:@"FB_ID"]
        withCompletionBlock:^(NSError *error) {
            if (error != nil) {
                NSLog(@"An error occurred: %@", error);
            } else {
          
                NSLog(@"Saved location successfully!");
                

            }
        }];
    
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



- (IBAction)SetCurrentLocationBtn:(id)sender {
    geoCoder=[CLGeocoder new];
    // CLLocation *locationk=[[CLLocation alloc]initWithLatitude:28.5700 longitude:77.3200];
    [geoCoder reverseGeocodeLocation:loc.location completionHandler:^(NSArray *plmk,NSError *error)
     {
         CLPlacemark *placmk=plmk[0];
         [self.delegate returnLocation:[NSString stringWithFormat:@"%@, %@",placmk.locality,placmk.subLocality] placeid:@""];
         
     }];
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [_geoObject getLocationForKey:@"firebase-location" withCallback:^(CLLocation *locationz, NSError *error) {
        locationFB=locationz;
    }];
    
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{//&components=country:in
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (CFStringRef)searchText,
                                                                                                    NULL,
                                                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                    kCFStringEncodingUTF8 ));
    NSLog(@"__++++_+_+_+_+_+>>>>>%@",encodedString);
    NSURLRequest *req=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&location=%f%f&radius=50000&key=AIzaSyBNjJyE7PJCMrl57DTX1c8Bnkj3-L2ApWE",encodedString,loc.location.coordinate.latitude,loc.location.coordinate.longitude]]];
    con=[NSURLConnection connectionWithRequest:req delegate:self];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{   [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    webdata=[NSMutableData new];
    //arrayWithObject:@"aa"];
    
    
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{   // NSLog(@"1");
    
    [webdata appendData:data];
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.address removeAllObjects];
    [self.placeId removeAllObjects];

    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    //NSLog(@"3");
    
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:webdata options:0 error:nil];
    NSArray *results=dic[@"predictions"];
    for (NSDictionary *dicx in results) {
        NSString *name=dicx[@"description"];
        NSString *placeId=dicx[@"place_id"];

        [self.address addObject:name];
        [self.placeId addObject:placeId];

        
    }
   //m NSLog(@"====%@",dic);
    
    [self.tableViewOutlet reloadData];
    
    
}
//-(void)connection:(nonnull NSURLConnection *)connection didFailWithError:(nonnull NSError *)error
//{
//    NSLog(@"%@",error);
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"2");
    NSString *locc=[[NSUserDefaults standardUserDefaults]valueForKey:@"last_location"];

    if (self.address.count==0&& locc.length>0) {
        return 1;
    }
    return [self.address count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"4");
    
    NSString *ci=@"a";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ci];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ci];
    }
    if (self.address.count==0) {
        cell.imageView.image=[UIImage imageNamed:@"pin.brightred.png"];

            cell.textLabel.text=[[NSUserDefaults standardUserDefaults]valueForKey:@"last_location"];

           }
    else
    {
        cell.imageView.image=[UIImage imageNamed:@"pin.brightred.png"];

    cell.textLabel.text=self.address[indexPath.row];
    }
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.address.count>0)
    {
        [[NSUserDefaults standardUserDefaults]setObject:self.address[indexPath.row] forKey:@"last_location"];
        [[NSUserDefaults standardUserDefaults]setObject:self.placeId[indexPath.row] forKey:@"place_id"];

        [self.delegate returnLocation:self.address[indexPath.row] placeid:self.placeId[indexPath.row]];
    }
    else{
        [self.delegate returnLocation:[[NSUserDefaults standardUserDefaults]valueForKey:@"last_location"] placeid:[[NSUserDefaults standardUserDefaults]valueForKey:@"place_id"]];
    }
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
    //NSLog(@"5");
    
}
//- (BOOL)prefersStatusBarHidden
//{
//    return YES;
//}



@end
