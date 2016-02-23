//
//  SaveFoodsViewController.m
//  KhmerFood
//
//  Created by Yoman on 12/17/15.
//  Copyright © 2015 Donut. All rights reserved.
//

#import "SaveFoodsViewController.h"

#import "CardViewMe.h"
#import "YSLDraggableCardContainer.h"

#define RGB(r, g, b)	 [UIColor colorWithRed: (r) / 255.0 green: (g) / 255.0 blue: (b) / 255.0 alpha : 1]

@interface SaveFoodsViewController () <YSLDraggableCardContainerDelegate, YSLDraggableCardContainerDataSource>

@property (nonatomic, strong) YSLDraggableCardContainer *container;
@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation SaveFoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(235, 235, 235);
    
    _container = [[YSLDraggableCardContainer alloc]init];
    _container.frame = CGRectMake(25 , self.view.frame.size.height / 6 , self.view.frame.size.width - 50, self.view.frame.size.height / 2);
    _container.dataSource = self;
    _container.delegate = self;
    _container.canDraggableDirection = YSLDraggableDirectionLeft | YSLDraggableDirectionRight ;
    [self.view addSubview:_container];
    
    _datas = [NSMutableArray array];
    
     NSArray *array = [[NSArray alloc] initWithObjects:@"header.jpg",@"food1.jpg",@"Test",@"food.jpg",@"Test",@"food.jpg",@"header.jpg", nil];
    
    for (int i = 0; i < array.count; i++) {
        NSDictionary *dict = @{@"image" : [NSString stringWithFormat:@"%@",array[i]],
                               @"name" : @"Yo Testing Demo"};
        [_datas addObject:dict];
    }
    [_container reloadCardContainer];

}

#pragma mark -- YSLDraggableCardContainer DataSource
- (UIView *)cardContainerViewNextViewWithIndex:(NSInteger)index     {
    NSDictionary *dict = _datas[index];
    CardViewMe *view;
    view = [[CardViewMe alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 50, self.view.frame.size.height / 2)];
    view.backgroundColor = [UIColor whiteColor];
    view.imageView.image = [UIImage imageNamed:dict[@"image"]];
    view.label.text = [NSString stringWithFormat:@"%@  %ld",dict[@"name"],(long)index];
    view.labelName.text = [NSString stringWithFormat:@"%@  %ld",dict[@"name"],(long)index];
    return view;
}
- (NSInteger)cardContainerViewNumberOfViewInIndex:(NSInteger)index  {
    return _datas.count;
}

#pragma mark -- YSLDraggableCardContainer Delegate
- (void)cardContainerView:(YSLDraggableCardContainer *)cardContainerView didEndDraggingAtIndex:(NSInteger)index draggableView:(UIView *)draggableView draggableDirection:(YSLDraggableDirection)draggableDirection{
    if (draggableDirection == YSLDraggableDirectionLeft) {
        [cardContainerView movePositionWithDirection:draggableDirection
                                         isAutomatic:NO];
    }
    
    if (draggableDirection == YSLDraggableDirectionRight) {
        [cardContainerView movePositionWithDirection:YSLDraggableDirectionDown isAutomatic:YES undoHandler:^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Information"
                                                                                     message:@"Delete man ?"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [cardContainerView movePositionWithDirection:YSLDraggableDirectionRight isAutomatic:YES];
            }]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [cardContainerView movePositionWithDirection:YSLDraggableDirectionDefault isAutomatic:YES];
            }]];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }];
    }
    
    NSLog(@"---> %d",index);
}

- (void)cardContainderView:(YSLDraggableCardContainer *)cardContainderView updatePositionWithDraggableView:(UIView *)draggableView draggableDirection:(YSLDraggableDirection)draggableDirection widthRatio:(CGFloat)widthRatio heightRatio:(CGFloat)heightRatio{
    CardViewMe *view = (CardViewMe *)draggableView;
    
    if (draggableDirection == YSLDraggableDirectionDefault) {
        view.selectedView.alpha = 0;
    }
    
    if (draggableDirection == YSLDraggableDirectionLeft) {
        view.selectedView.backgroundColor = RGB(215, 104, 91);
        view.selectedView.alpha = widthRatio > 0.8 ? 0.8 : widthRatio;
    }
    
    if (draggableDirection == YSLDraggableDirectionRight) {
        view.selectedView.backgroundColor = RGB(114, 209, 142);
        view.selectedView.alpha = widthRatio > 0.8 ? 0.8 : widthRatio;
    }
    
}

- (void)cardContainerViewDidCompleteAll:(YSLDraggableCardContainer *)container;{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [container reloadCardContainer];
    });
}

- (void)cardContainerView:(YSLDraggableCardContainer *)cardContainerView didSelectAtIndex:(NSInteger)index draggableView:(UIView *)draggableView{
    NSLog(@"++ index : %ld",(long)index);
}



@end
