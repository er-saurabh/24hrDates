//
//  LocationFirebaseViewController.h
//  48hr Dates
//
//  Created by Ankit
//  Copyright (c) 2015 Fourth Screen Labs Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GeoFire/GeoFire.h>
#import <Firebase/Firebase.h>

@class locationFirebase;
@protocol locationFirebaseDelegate <NSObject>
-(void)returnLocation:(NSString*)locationReturn placeid:(NSString*)placeID;
@end

@interface LocationFirebaseViewController:UIViewController<UITableViewDelegate,UITableViewDataSource,NSURLConnectionDataDelegate,UISearchDisplayDelegate,UISearchBarDelegate,CLLocationManagerDelegate>
{
    CLGeocoder *geoCoder;
    NSTimer *timer;
    CLLocationManager *loc;
    CLLocation *location,*locationFB;
    NSURLConnection *con;
    NSMutableData *webdata;
}
- (IBAction)SetCurrentLocationBtn:(id)sender;
@property(nonatomic,strong)id<locationFirebaseDelegate> delegate;
@property(nonatomic,strong)Firebase *fBase;
@property(nonatomic,strong)GeoFire *geoObject;
@property (weak, nonatomic) IBOutlet UITableView *tableViewOutlet;
@property(nonatomic,strong)NSMutableArray *address,*placeId;
- (IBAction)cancelButton:(id)sender;



@end
