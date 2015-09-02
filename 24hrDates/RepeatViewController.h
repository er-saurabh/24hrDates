//
//  RepeatViewController.h
//  24hrDates
//
//  Created by Ankit on 20/08/15.
//  Copyright (c) 2015 Ankit. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RepeatViewController;
@protocol RepeatDelegate <NSObject>

-(void)repeatValueReturn:(NSString*)repeat;

@end

@interface RepeatViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic)id <RepeatDelegate> delegate;
@end
