//
//  RecommendFoodViewController.m
//  KhmerFood
//
//  Created by kvc on 1/4/16.
//  Copyright © 2016 Donut. All rights reserved.
//

#import "RecommendFoodViewController.h"
#import "CustomCollectionViewCell.h"
#import <Realm/Realm.h>
#import "AllFoodModel.h"
#import "UIImageView+WebCache.h"
#import "FoodDetailViewController.h"

@interface RecommendFoodViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
{
    UIImageView *imageView;
    UILabel *foodName;
    UILabel *foodType;
    RLMResults<AllFoodModel *> *recommentFoodList;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation RecommendFoodViewController

#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    self.navigationController.navigationBar.barTintColor = NaviStandartColor;
    [AppUtils settingLeftButton:self action:@selector(lettButtonClicked:) normalImageCode:@"go_back.png" highlightImageCode:nil];
    
    [self setTitleForNavigationbar:@"ម្ហូបដែលអ្នកគួរសាក"];
    if ([_receiveArrayData count] == 0) {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"foodType = %@",[self checkFoodType:_receiveData]];
        recommentFoodList = [AllFoodModel objectsWithPredicate:pred];
    }
    
}

-(void)viewWillAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma makr - set up view

-(UIView *)setupViewForCell:(float)width height:(float)height {
    
    UIView *containView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    containView.tag = 90;
    containView.backgroundColor = [UIColor whiteColor];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, (height / 2) + 47)];
    imageView.tag = 91;
    
    foodName = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.frame.size.height - 5, width, 26)];
    foodName.tag = 92;
    [foodName setFont:[UIFont boldSystemFontOfSize:17]];
    
    foodName.textColor = [UIColor blackColor];
    foodName.backgroundColor = [UIColor whiteColor];
    
    
    foodType = [[UILabel alloc] initWithFrame:CGRectMake(0, (foodName.frame.size.height + foodName.frame.origin.y) - 5, width, 18)];
    foodType.tag = 93;
    [foodType setFont:[UIFont systemFontOfSize:12]];
    foodType.textColor = [UIColor lightGrayColor];
    
    [containView addSubview:imageView];
    [containView addSubview:foodName];
    [containView addSubview:foodType];
    
    containView.layer.cornerRadius = 5;
    containView.layer.masksToBounds = true;
    imageView.layer.cornerRadius = 5;
    imageView.layer.masksToBounds = true;
    
    return containView;
}

#pragma mark - collectionview methods

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [cell.contentView addSubview:[self setupViewForCell:cell.contentView.frame.size.width height:cell.contentView.frame.size.height]];
    
    if ([_receiveArrayData count] == 0) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:[recommentFoodList objectAtIndex:indexPath.row].foodImage]];
        foodType.text = [NSString stringWithFormat:@" %@",[recommentFoodList objectAtIndex:indexPath.row].foodType];
        foodName.text = [NSString stringWithFormat:@" %@",[recommentFoodList objectAtIndex:indexPath.row].foodName];
    } else {
        [imageView sd_setImageWithURL:[NSURL URLWithString: [[_receiveArrayData objectAtIndex:indexPath.row] objectForKey:@"FD_IMG"]]];
        foodType.text = [NSString stringWithFormat:@" %@",[[_receiveArrayData objectAtIndex:indexPath.row] objectForKey:@"FD_NAME"]];
        foodName.text = [NSString stringWithFormat:@" %@",[[_receiveArrayData objectAtIndex:indexPath.row] objectForKey:@"FD_NAME"]];
    }
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (![_receiveArrayData count] || [_receiveArrayData count] == 0) {
        return [recommentFoodList count];
    }
    return [_receiveArrayData count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.view.frame.size.width / 2) - 10, 177);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *tempDic = nil;
    
    if ([recommentFoodList count] == 0) {
        tempDic = @{@"FD_ID":[[_receiveArrayData objectAtIndex:indexPath.row] objectForKey:@"FD_ID"],
                    @"FD_NAME":[[_receiveArrayData objectAtIndex:indexPath.row] objectForKey:@"FD_NAME"],
                    @"FD_DETAIL":[[_receiveArrayData objectAtIndex:indexPath.row] objectForKey:@"FD_DETAIL"],
                    @"FD_COOK_TIME":[[_receiveArrayData objectAtIndex:indexPath.row] objectForKey:@"FD_COOK_TIME"],
                    @"FD_IMG":[[_receiveArrayData objectAtIndex:indexPath.row] objectForKey:@"FD_IMG"],
                    @"FD_RATE":@"",
                    @"FD_TYPE":@"",
                    @"FD_TIME_WATCH":@""
                    };
    } else {
        AllFoodModel *obj = [recommentFoodList objectAtIndex:indexPath.row];
        tempDic = @{@"FD_ID":obj.foodID,
                    @"FD_NAME":obj.foodName,
                    @"FD_DETAIL":obj.foodDetail,
                    @"FD_COOK_TIME":obj.foodCookTime,
                    @"FD_IMG":obj.foodImage,
                    @"FD_RATE":obj.foodRate,
                    @"FD_TYPE":obj.foodType,
                    @"FD_TIME_WATCH":obj.foodTimeWatch
                    };
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"detail" sender:tempDic];
    });
}

#pragma mark - segue method
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detail"]) {
        FoodDetailViewController *vc = [segue destinationViewController];
        vc.receiveData = sender;
    }
}

#pragma mark - other methods

-(void)setTitleForNavigationbar:(NSString *)title {
    UILabel *titleLable =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
    [titleLable setFont:[UIFont systemFontOfSize:17]];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.text = title;
    self.navigationItem.titleView = titleLable;
}

-(void)lettButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - check food type
-(NSString *)checkFoodType:(NSString *)type {
    NSString *fType = @"";
    
    if ([type isEqualToString:@"ឆា"]) {
        fType = @"D1";
    }else if ([type isEqualToString:@"ស្ងោ"]) {
        fType = @"D2";
    }else if ([type isEqualToString:@"ចៀន"]) {
        fType = @"D3";
    }else if ([type isEqualToString:@"ញាំ"]) {
        fType = @"D4";
    }else if ([type isEqualToString:@"ចំហុយ"]) {
        fType = @"D5";
    }else if ([type isEqualToString:@"បំពង"]) {
        fType = @"D6";
    }else if ([type isEqualToString:@"ភ្លៀរ"]) {
        fType = @"D7";
    }else if ([type isEqualToString:@"អាំង"]) {
        fType = @"D8";
    }
    
    return fType;
}
@end
