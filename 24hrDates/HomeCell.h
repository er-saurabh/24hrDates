//
//  HomeCell.h
//  24hrDates
//
//  Created by Ankit on 25/08/15.
//  Copyright (c) 2015 Ankit. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeCell;
@protocol SwipeableCellDelegate <NSObject>

-(void)buttonClicked:(UIButton*)sender :(HomeCell*)cell;
- (void)cellDidOpen:(UITableViewCell *)cell;
- (void)cellDidClose:(UITableViewCell *)cell;
@end
@interface HomeCell : UITableViewCell<UIGestureRecognizerDelegate>

- (void)openCell;
@property (nonatomic, weak) id <SwipeableCellDelegate> delegate;

//--------------------- nib outlets----------------------//

@property (weak, nonatomic) IBOutlet UIView *typeView;

@property(nonatomic,retain)NSString*fbID;
@property (weak, nonatomic) IBOutlet UIButton *rightSideBtn;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicView;
@property (weak, nonatomic) IBOutlet UILabel *nameHeaderText;
@property (weak, nonatomic) IBOutlet UILabel *descriptionText;
@property (weak, nonatomic) IBOutlet UILabel *timeSlot;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *amPmLabel;
@property (weak, nonatomic) IBOutlet UIButton *swipeBtn;
@property (weak, nonatomic) IBOutlet UIView *myContentView;
@property(nonatomic,retain)NSString *userfreetime;
@property(nonatomic,retain)NSString *cellType;
@property(nonatomic,retain)NSDate *date;

//---------------------@end nib outlets----------------------//



@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, assign) CGPoint panStartPoint;
@property (nonatomic, assign) CGFloat startingRightLayoutConstraintConstant;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewRightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewLeftConstraint;
@end
