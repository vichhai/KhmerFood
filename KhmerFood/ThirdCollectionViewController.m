//
//  ThirdCollectionViewController.m
//  KhmerFood
//
//  Created by kvc on 12/17/15.
//  Copyright © 2015 Donut. All rights reserved.
//

#import "ThirdCollectionViewController.h"
#import "CustomCollectionViewCell.h"
#import "FoodModel.h"
#import "UIImageView+WebCache.h"

@interface ThirdCollectionViewController ()
{
    NSArray *arrayResult;
}
@property (weak, nonatomic) IBOutlet UICollectionView *firstCollectionView;
@end

@implementation ThirdCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[AppUtils readObjectFromRealm:[[FoodModel alloc] init]] count] != 0) {
        FoodModel *objFood = [[AppUtils readObjectFromRealm:[[FoodModel alloc] init]] objectAtIndex:0];
        NSDictionary *tempDic = (NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:objFood.foodRecord];
        arrayResult = [[NSArray alloc] initWithArray:[tempDic objectForKey:@"AFOOD"]];
        [self.firstCollectionView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell2" forIndexPath:indexPath];
    cell.mylabel.text = [[arrayResult objectAtIndex:indexPath.row] objectForKey:@"FD_NAME"];
    cell.foodType.text = [[arrayResult objectAtIndex:indexPath.row] objectForKey:@"FD_COOK_TIME"]; //FD_IMG
    [cell.myImage sd_setImageWithURL:[NSURL URLWithString:[[arrayResult objectAtIndex:indexPath.row] objectForKey:@"FD_IMG"]]];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [arrayResult count];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"index path: %ld",(long)indexPath.row);
}

@end
