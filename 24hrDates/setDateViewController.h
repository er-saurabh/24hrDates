//
//  setDateViewController.h
//  24hrDates
//
//  Created by Ankit on 07/08/15.
//  Copyright (c) 2015 Ankit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionSheetDatePicker.h"
#import "LocationFirebaseViewController.h"
#import "RepeatViewController.h"


@interface setDateViewController : UIViewController<locationFirebaseDelegate,UITableViewDelegate,RepeatDelegate>
{
    UITextView *descriptionTextView;

}


@end
