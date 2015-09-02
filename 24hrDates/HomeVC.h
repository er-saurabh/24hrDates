//
//  HomeVC.h
//  24hrDates
//
//  Created by Ankit on 05/08/15.
//  Copyright (c) 2015 Ankit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GeoFire/GeoFire.h>
@interface HomeVC : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property(nonatomic,strong)GeoFire *geoObject;

@property (nonatomic, strong) NSMutableSet *cellsCurrentlyEditing;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,retain) NSMutableDictionary * userDataResponse,*geoLocDataResponse;
@property(nonatomic,retain)NSMutableArray*availableUsers;
@end
