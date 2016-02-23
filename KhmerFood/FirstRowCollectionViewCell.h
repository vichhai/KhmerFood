//
//  FirstRowCollectionViewCell.h
//  KhmerFood
//
//  Created by kvc on 12/17/15.
//  Copyright © 2015 Donut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KFViewController.h"
#import "FoodModel.h"
@interface FirstRowCollectionViewCell : KFViewController <UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSArray *arrayResult;
}
@property (weak, nonatomic) IBOutlet UICollectionView *firstCollectionView;

@end
