//
//  IntroView.h

#import <UIKit/UIKit.h>

@protocol ABCIntroViewDelegate <NSObject>

-(void)onDoneButtonPressed;

@end

@interface ABCIntroView : UIView
@property id<ABCIntroViewDelegate> delegate;
-(void)viewSetup;
@end
