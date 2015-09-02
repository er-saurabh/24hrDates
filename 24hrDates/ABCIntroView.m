//
//  IntroView.m


#import "ABCIntroView.h"

@interface ABCIntroView () <UIScrollViewDelegate>
{
    NSInteger currentPage;
    NSTimer *timer;
}
@property (strong, nonatomic)  UIScrollView *scrollView;
@property (strong, nonatomic)  UIPageControl *pageControl;
@property UIView *holeView;
@property UIView *circleView;

@end

@implementation ABCIntroView
-(void)viewSetup
{
    if ([[UIScreen mainScreen]bounds ].size.height<481)
    {
        [[[self superview] viewWithTag:7] setHidden:1];
    }
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    self.scrollView.pagingEnabled = YES;
    [self addSubview:self.scrollView];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height*.825, self.frame.size.width, 10)];
    self.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    self.pageControl.pageIndicatorTintColor=[UIColor grayColor];
    [self addSubview:self.pageControl];
    
    [self createViewOne];
    [self createViewTwo];
    [self createViewThree];
    [self bringSubviewToFront:[self viewWithTag:5]];
    [self bringSubviewToFront:[self viewWithTag:6]];
    currentPage=0;
    
    //Done Button
    self.pageControl.numberOfPages = 3;
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width*3,self.scrollView.frame.size.height);
    
    //This is the starting point of the ScrollView
    CGPoint scrollPoint = CGPointMake(0, 0);
    [self.scrollView setContentOffset:scrollPoint animated:YES];
   timer= [NSTimer scheduledTimerWithTimeInterval:4
                                      target:self
                                    selector:@selector(scrollPages)
                                    userInfo:Nil
                                          repeats:YES];
    [timer fire];
    
    
}

-(void)scrollPages{
    if(self.pageControl.currentPage==2)
    {
        [timer invalidate];
        timer=nil;
    }
    [self scrollToPage:currentPage%3];
    currentPage++;
}
-(void)scrollToPage:(NSInteger)aPage{
    float myPageWidth = [self.scrollView frame].size.width;
  //  NSLog(@"aaaaaaaa%@",NSStringFromCGPoint(self.scrollView.contentOffset));
    [self.scrollView setContentOffset:CGPointMake(aPage*myPageWidth,0) animated:YES];

}
- (IBAction)onFinishedIntroButtonPressed:(id)sender {
    [self.delegate onDoneButtonPressed];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y != 0) {
        CGPoint offset = scrollView.contentOffset;
        offset.y = 0;
        scrollView.contentOffset = offset;
    }
    CGFloat pageWidth = CGRectGetWidth(self.bounds);

    CGFloat pageFraction = self.scrollView.contentOffset.x / pageWidth;
    self.pageControl.currentPage = roundf(pageFraction);

    
}


-(void)createViewOne{
    
    UIView *view = [[UIView alloc] initWithFrame:self.frame];

    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width*.1, self.frame.size.height*.05, self.frame.size.width*.8,500)];
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    imageview.image = [UIImage imageNamed:@"phone_1.png"];
    [view addSubview:imageview];
    UIView *viewTemp=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY([self viewWithTag:6].frame), [UIScreen mainScreen].bounds.size.width, 200)];
    viewTemp.backgroundColor=[UIColor whiteColor];
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width*.1, 0, self.frame.size.width*.8, 60)];
   // descriptionLabel.backgroundColor=[UIColor whiteColor];
    descriptionLabel.text = [NSString stringWithFormat:@"Enter your free time and we'll match you to people nearby, interesed in meeting at the same time."];
    descriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:14.0];
    descriptionLabel.textColor = [UIColor blackColor];
    descriptionLabel.textAlignment =  NSTextAlignmentCenter;
    descriptionLabel.numberOfLines = 0;
    [descriptionLabel sizeToFit];
    [viewTemp addSubview:descriptionLabel];
    [view addSubview:viewTemp];
        self.scrollView.delegate = self;
    [self.scrollView addSubview:view];
    
}


-(void)createViewTwo{
    
    CGFloat originWidth = self.frame.size.width;
    CGFloat originHeight = self.frame.size.height;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(originWidth, 0, originWidth, originHeight)];
    

    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width*.1, self.frame.size.height*.05, self.frame.size.width*.8,500)];
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    imageview.image = [UIImage imageNamed:@"phone_2.png"];
    [view addSubview:imageview];
    UIView *viewTemp=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY([self viewWithTag:6].frame), [UIScreen mainScreen].bounds.size.width, 200)];
    viewTemp.backgroundColor=[UIColor whiteColor];
    UILabel *descriptionLabel =[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width*.1, 0, self.frame.size.width*.8, 60)];
    descriptionLabel.text = [NSString stringWithFormat:@"If someone you want to meet is interested in meeting too..."];
    descriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:14.0];
    descriptionLabel.textColor = [UIColor blackColor];
    descriptionLabel.textAlignment =  NSTextAlignmentCenter;
    descriptionLabel.numberOfLines = 0;
    [descriptionLabel sizeToFit];
    [viewTemp addSubview:descriptionLabel];
    [view addSubview:viewTemp];
    
    
    self.scrollView.delegate = self;
    [self.scrollView addSubview:view];
    
}

-(void)createViewThree{
    
    CGFloat originWidth = self.frame.size.width;
    CGFloat originHeight = self.frame.size.height;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(originWidth*2, 0, originWidth, originHeight)];
    
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width*.1, self.frame.size.height*.05, self.frame.size.width*.8,500)];
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    imageview.image = [UIImage imageNamed:@"phone_2.png"];
    [view addSubview:imageview];
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    imageview.image = [UIImage imageNamed:@"phone_3.png"];
    [view addSubview:imageview];
    UIView *viewTemp=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY([self viewWithTag:6].frame), [UIScreen mainScreen].bounds.size.width, 200)];
    viewTemp.backgroundColor=[UIColor whiteColor];
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width*.1,0, self.frame.size.width*.8, 60)];
    descriptionLabel.text = [NSString stringWithFormat:@"Chat in the run up to your date."];
    descriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:14.0];
    descriptionLabel.textColor = [UIColor blackColor];
    descriptionLabel.textAlignment =  NSTextAlignmentCenter;
    descriptionLabel.numberOfLines = 1;
   // [descriptionLabel sizeToFit];
    [viewTemp addSubview:descriptionLabel];
    [view addSubview:viewTemp];
        self.scrollView.delegate = self;
    [self.scrollView addSubview:view];
    
}



@end