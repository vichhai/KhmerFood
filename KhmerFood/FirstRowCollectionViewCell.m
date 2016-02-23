//
//  FirstRowCollectionViewCell.m
//  KhmerFood
//
//  Created by kvc on 12/17/15.
//  Copyright © 2015 Donut. All rights reserved.
//

#import "FirstRowCollectionViewCell.h"
#import "CustomCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@implementation FirstRowCollectionViewCell

-(void)viewDidLoad {

    if ([[AppUtils readObjectFromRealm:[[FoodModel alloc] init]] count] != 0) {
        FoodModel *objFood = [[AppUtils readObjectFromRealm:[[FoodModel alloc] init]] objectAtIndex:0];
        NSDictionary *tempDic = (NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:objFood.foodRecord];
        arrayResult = [[NSArray alloc] initWithArray:[tempDic objectForKey:@"RANDOM"]];
        [self.firstCollectionView reloadData];
        [self.firstCollectionView layoutIfNeeded];
        
    }
    
}

#pragma mark: - collecitonView Delegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.mylabel.text = [[arrayResult objectAtIndex:indexPath.row] objectForKey:@"FD_NAME"];
    cell.foodType.text = [[arrayResult objectAtIndex:indexPath.row] objectForKey:@"FD_COOK_TIME"]; //FD_IMG
    [cell.myImage sd_setImageWithURL:[NSURL URLWithString:[[arrayResult objectAtIndex:indexPath.row] objectForKey:@"FD_IMG"]]];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [arrayResult count];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *senderDic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)indexPath.row],@"tagValue",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goToDetail" object:self userInfo:senderDic];
    
}

@end
