//
//  CardView.m
//  ZLSwipeableViewDemo
//
//  Created by Zhixuan Lai on 11/1/14.
//  Copyright (c) 2014 Zhixuan Lai. All rights reserved.
//

#import "CardView.h"

@implementation CardView
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        //// Color Declarations
        UIColor* shadowColor2 = [UIColor colorWithRed: 0.209 green: 0.209 blue: 0.209 alpha: 1];
        
        //// Shadow Declarations
        UIColor* shadow = [shadowColor2 colorWithAlphaComponent: 0.73];
        CGSize shadowOffset = CGSizeMake(3.1/2.0, -0.1/2.0);
        CGFloat shadowBlurRadius = 12/2.0;
        self.layer.shadowColor = [shadow CGColor];
        self.layer.shadowOpacity = 0.73;
        self.layer.shadowOffset = shadowOffset;
        self.layer.shadowRadius = shadowBlurRadius;
        self.layer.shouldRasterize = YES;
        
        
    }
    return self;
}

-(void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    CGFloat frameWidth = rect.size.width;
    CGFloat frameHeight = rect.size.height;
    CGFloat cornerRadius = 10;
    
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor* cardColor = self.cardColor;
    
    //// card1
    {
        CGContextSaveGState(context);
//                CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, [shadow CGColor]);
        CGContextBeginTransparencyLayer(context, NULL);
        
        //// Rectangle 4 Drawing
        UIBezierPath* rectangle4Path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, frameWidth, frameHeight) cornerRadius: cornerRadius];
        [cardColor setFill];
        [rectangle4Path fill];
        
        CGContextEndTransparencyLayer(context);
        CGContextRestoreGState(context);
    }
    
   
}
@end


//
//  SaveFoodsViewController.m
//  KhmerFood
//
//  Created by Yoman on 12/17/15.
//  Copyright © 2015 Donut. All rights reserved.
//

//#import "SaveFoodsViewController.h"
//
//#import "ZLSwipeableView.h"
//#import "UIColor+FlatColors.h"
//#import "CardView.h"
//
//@interface SaveFoodsViewController () <ZLSwipeableViewDataSource, ZLSwipeableViewDelegate>{
//    
//}
//
//@property (weak, nonatomic) IBOutlet ZLSwipeableView *swipeableView;
//@property (strong, nonatomic) IBOutlet UILabel *lblWarning;
//
//@property (nonatomic, strong) NSArray *UserArr;
//
//@property (nonatomic) NSUInteger colorIndex;
//@property (nonatomic) NSUInteger TestMe11;
//
//@end
//
//@implementation SaveFoodsViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view, typically from a nib.
//    self.colorIndex = 0;
//    self.TestMe11   = 0;
//    
//    self.UserArr = @[@"user1",@"user2",@"user3",@"user4",@"user5"];
//    
//    [self.swipeableView setNeedsLayout];
//    [self.swipeableView layoutIfNeeded];
//    
//    self.swipeableView.dataSource = self;
//    self.swipeableView.delegate = self;
//}
//
////[self.swipeableView swipeTopViewToLeft];
////[self.swipeableView swipeTopViewToRight];
//// self.colorIndex = 0;
////[self.swipeableView discardAllSwipeableViews];
////[self.swipeableView loadNextSwipeableViewsIfNeeded];
//
//
//#pragma mark - ZLSwipeableViewDelegate
//- (void)swipeableView: (ZLSwipeableView *)swipeableView didSwipeLeft:(UIView *)view {
//    NSLog(@"did swipe left");
//    
//    _TestMe11++;
//    NSLog(@"--> %lu",(unsigned long)_TestMe11);
//    
//    if(_UserArr.count == _TestMe11){
//        self.colorIndex = 0;
//        _TestMe11 = 0;
//        [self.swipeableView discardAllSwipeableViews];
//        [self.swipeableView loadNextSwipeableViewsIfNeeded];
//        return;
//    }
//    
//}
//- (void)swipeableView: (ZLSwipeableView *)swipeableView didSwipeRight:(UIView *)view {
//    NSLog(@"did swipe right");
//    _TestMe11++;
//    //    NSLog(@"--> %lu",(unsigned long)_TestMe11);
//    //    NSLog(@"--> %@",_UserArr[_TestMe11-1]);
//    
//    if(_UserArr.count == _TestMe11){
//        self.colorIndex = 0;
//        _TestMe11 = 0;
//        [self.swipeableView discardAllSwipeableViews];
//        [self.swipeableView loadNextSwipeableViewsIfNeeded];
//        return;
//    }
//}
//- (void)swipeableView: (ZLSwipeableView *)swipeableView swipingView:(UIView *)view atLocation:(CGPoint)location {
//    //        NSLog(@"swiping at location: x %f, y%f", location.x, location.y);
//    
//    if(location.x > 200){
//        _lblWarning.text = @"Delete";
//        
//        UIAlertController * alert=   [UIAlertController
//                                      alertControllerWithTitle:@"Food's Name"
//                                      message:[NSString stringWithFormat:@"%@",_UserArr[_TestMe11]]
//                                      preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction* yesButton = [UIAlertAction
//                                    actionWithTitle:@"Yes, please"
//                                    style:UIAlertActionStyleDefault
//                                    handler:^(UIAlertAction * action)
//                                    {
//                                        [self.swipeableView swipeTopViewToRight];
//                                        [alert dismissViewControllerAnimated:YES completion:nil];
//                                        
//                                    }];
//        UIAlertAction* noButton = [UIAlertAction
//                                   actionWithTitle:@"No, thanks"
//                                   style:UIAlertActionStyleDefault
//                                   handler:^(UIAlertAction * action)
//                                   {
//                                       [alert dismissViewControllerAnimated:YES completion:nil];
//                                       
//                                   }];
//        
//        [alert addAction:yesButton];
//        [alert addAction:noButton];
//        
//        [self presentViewController:alert animated:YES completion:nil];
//        
//    }else{
//        _lblWarning.text = @"Next";
//    }
//    
//}
//- (IBAction)tapOnFoodAction:(UITapGestureRecognizer *)sender {
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Food"
//                                                    message:[NSString stringWithFormat:@"%@",_UserArr[_TestMe11]]
//                                                   delegate:self
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil];
//    [alert show];
//}
//
//#pragma mark - ZLSwipeableViewDataSource
//- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView {
//    if (self.colorIndex<self.UserArr.count) {
//        CardView *viewCard = [[CardView alloc] initWithFrame:swipeableView.bounds];
//        viewCard.cardColor = [UIColor whiteColor];
//        
//        
//        UIImageView *ImageME = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, swipeableView.bounds.size.width, swipeableView.bounds.size.height - 70)];
//        ImageME.backgroundColor= [UIColor lightGrayColor];
//        ImageME.image = [UIImage imageNamed:@"Test.png"];
//        [viewCard addSubview:ImageME];
//        
//        
//        UILabel *lblFoodName = [[UILabel alloc]initWithFrame:CGRectMake(10, swipeableView.bounds.size.height - 65, swipeableView.bounds.size.width - 40, 30)];
//        lblFoodName.text = @"ខសាច់ជ្រូកបែបចិន";
//        [viewCard addSubview:lblFoodName];
//        
//        UILabel *lblTypeName = [[UILabel alloc]initWithFrame:CGRectMake(10, swipeableView.bounds.size.height - 35, swipeableView.bounds.size.width - 40, 30)];
//        lblTypeName.text = @"ប្រភេទ ៖​ សម្ល";
//        [viewCard addSubview:lblTypeName];
//        
//        
//        //        NSLog(@"%@",[NSString stringWithFormat:@"%@",self.UserArr[self.colorIndex]]);
//        
//        self.colorIndex++;
//        
//        return viewCard;
//    }
//    return nil;
//}
//
//
//@end


