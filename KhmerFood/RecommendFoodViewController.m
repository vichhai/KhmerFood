//
//  RecommendFoodViewController.m
//  KhmerFood
//
//  Created by kvc on 1/4/16.
//  Copyright © 2016 Donut. All rights reserved.
//

#import "RecommendFoodViewController.h"
#import "CustomCollectionViewCell.h"
@interface RecommendFoodViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation RecommendFoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    self.navigationController.navigationBar.barTintColor = NaviStandartColor;
    [AppUtils settingLeftButton:self action:@selector(lettButtonClicked:) normalImageCode:@"go_back.png" highlightImageCode:nil];
    
    [self setTitleForNavigationbar:@"ម្ហូបដែលអ្នកគួរសាក"];
    self.collectionView.hidden = true;
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
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, (height / 2) + 47)];
    imageView.tag = 91;
    imageView.image = [UIImage imageNamed:@"food.jpg"];
    
    
    UILabel *foodName = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.frame.size.height - 5, width, 26)];
    foodName.tag = 92;
    [foodName setFont:[UIFont boldSystemFontOfSize:17]];
    foodName.text = @"សម្លក្តាត";
    foodName.textColor = [UIColor blackColor];
    foodName.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *foodType = [[UILabel alloc] initWithFrame:CGRectMake(0, (foodName.frame.size.height + foodName.frame.origin.y) - 5, width, 18)];
    foodType.tag = 93;
    [foodType setFont:[UIFont systemFontOfSize:12]];
    foodType.textColor = [UIColor lightGrayColor];
    foodType.text = @"Ah yeah by EXID";
    
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
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake((self.view.frame.size.width / 2) - 10, 177);
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
@end
