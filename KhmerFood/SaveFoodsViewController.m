//
//  SaveFoodsViewController.m
//  KhmerFood
//
//  Created by Yoman on 12/17/15.
//  Copyright © 2015 Donut. All rights reserved.
//

#import "SaveFoodsViewController.h"

#import "ZLSwipeableView.h"
#import "UIColor+FlatColors.h"
#import "CardView.h"

@interface SaveFoodsViewController () <ZLSwipeableViewDataSource, ZLSwipeableViewDelegate>
@property (weak, nonatomic) IBOutlet ZLSwipeableView *swipeableView;

@property (nonatomic, strong) NSArray *UserArr;

@property (nonatomic) NSUInteger colorIndex;
@property (nonatomic) NSUInteger TestMe11;
@end

@implementation SaveFoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.colorIndex = 0;
    self.TestMe11 = 0;
    
    self.UserArr = @[@"user1",@"user2",@"user3",@"user4",@"user5"];

    [self.swipeableView setNeedsLayout];
    [self.swipeableView layoutIfNeeded];
    
    self.swipeableView.dataSource = self;
    self.swipeableView.delegate = self;
}

//[self.swipeableView swipeTopViewToLeft];
//[self.swipeableView swipeTopViewToRight];
// self.colorIndex = 0;
//[self.swipeableView discardAllSwipeableViews];
//[self.swipeableView loadNextSwipeableViewsIfNeeded];

#pragma mark - ZLSwipeableViewDelegate
- (void)swipeableView: (ZLSwipeableView *)swipeableView didSwipeLeft:(UIView *)view {
    NSLog(@"did swipe left");
    
    _TestMe11++;
    NSLog(@"--> %lu",(unsigned long)_TestMe11);
    
    
    if(_UserArr.count == _TestMe11){
        self.colorIndex = 0;
        _TestMe11 = 0;
        [self.swipeableView discardAllSwipeableViews];
        [self.swipeableView loadNextSwipeableViewsIfNeeded];
        return;
    }
    
}
- (void)swipeableView: (ZLSwipeableView *)swipeableView didSwipeRight:(UIView *)view {
    NSLog(@"did swipe right");
    _TestMe11++;
    NSLog(@"--> %lu",(unsigned long)_TestMe11);
    
    if(_UserArr.count == _TestMe11){
        self.colorIndex = 0;
        _TestMe11 = 0;
        [self.swipeableView discardAllSwipeableViews];
        [self.swipeableView loadNextSwipeableViewsIfNeeded];
        return;
    }
}
- (void)swipeableView: (ZLSwipeableView *)swipeableView swipingView:(UIView *)view atLocation:(CGPoint)location {
    //    NSLog(@"swiping at location: x %f, y%f", location.x, location.y);

}

#pragma mark - ZLSwipeableViewDataSource
- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView {
    if (self.colorIndex<self.UserArr.count) {
        CardView *viewCard = [[CardView alloc] initWithFrame:swipeableView.bounds];
        viewCard.cardColor = [UIColor whiteColor];
        
       
        UIImageView *ImageME = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, swipeableView.bounds.size.width, swipeableView.bounds.size.height - 70)];
        ImageME.backgroundColor= [UIColor lightGrayColor];
        ImageME.image = [UIImage imageNamed:@"Test.png"];
        [viewCard addSubview:ImageME];
    
        
        UILabel *lblFoodName = [[UILabel alloc]initWithFrame:CGRectMake(10, swipeableView.bounds.size.height - 65, swipeableView.bounds.size.width - 40, 30)];
        lblFoodName.text = @"ខសាច់ជ្រូកបែបចិន";
        [viewCard addSubview:lblFoodName];
        
        UILabel *lblTypeName = [[UILabel alloc]initWithFrame:CGRectMake(10, swipeableView.bounds.size.height - 35, swipeableView.bounds.size.width - 40, 30)];
        lblTypeName.text = @"ប្រភេទ ៖​ សម្ល";
        [viewCard addSubview:lblTypeName];
        

//        NSLog(@"%@",[NSString stringWithFormat:@"%@",self.UserArr[self.colorIndex]]);
        
        self.colorIndex++;
        
        return viewCard;
    }
    return nil;
}


@end
