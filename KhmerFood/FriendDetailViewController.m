//
//  FriendDetailViewController.m
//  KhmerFood
//
//  Created by kvc on 3/15/16.
//  Copyright © 2016 Donut. All rights reserved.
//

#import "FriendDetailViewController.h"
#import "HeaderCollectionView.h"

@interface FriendDetailViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
{
    UIImageView *imageView;
    UILabel *foodName;
    UILabel *foodType;
}

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@end

@implementation FriendDetailViewController

#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = NaviStandartColor;
    [AppUtils settingLeftButton:self action:@selector(leftButtonClicked:) normalImageCode:@"x_button" highlightImageCode:nil];
    [_myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    _myCollectionView.backgroundColor = NaviStandartColor;
    _myCollectionView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button aciton

-(void)leftButtonClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

//setup view for collectionview cell
-(UIView *)setupViewForCell:(float)width height:(float)height {
    
    UIView *containView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    containView.tag = 330;
    containView.backgroundColor = [UIColor whiteColor];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, (height / 2) + 47)];
    imageView.tag = 331;
    
    foodName = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.frame.size.height - 5, width, 26)];
    foodName.tag = 332;
    [foodName setFont:[UIFont boldSystemFontOfSize:17]];
    
    foodName.textColor = [UIColor blackColor];
    foodName.backgroundColor = [UIColor whiteColor];
    
    
    foodType = [[UILabel alloc] initWithFrame:CGRectMake(0, (foodName.frame.size.height + foodName.frame.origin.y) - 5, width, 18)];
    foodType.tag = 333;
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

#pragma mark - other method

#pragma mark - collectionview delegate methods

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    HeaderCollectionView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
    return headerView;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [cell.contentView addSubview:[self setupViewForCell:cell.contentView.frame.size.width height:cell.contentView.frame.size.height]];
    
    foodName.text = @"សម្លក្ដាត";
    foodType.text = @"សម្លក្ដៅ";
    imageView.image = [UIImage imageNamed:@"info.png"];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 30;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.view.frame.size.width / 2) - 10, 177);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 5, 20, 5);
}
@end
