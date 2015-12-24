//
//  ThirdCollectionViewController.m
//  KhmerFood
//
//  Created by kvc on 12/17/15.
//  Copyright © 2015 Donut. All rights reserved.
//

#import "ThirdCollectionViewController.h"
#import "CustomCollectionViewCell.h"

@interface ThirdCollectionViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *firstCollectionView;
@end

@implementation ThirdCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell2" forIndexPath:indexPath];
    cell.mylabel.text = @"ម្ហូបអាគាំង";
    cell.foodType.text = @"ប្រភេទ អឺរ៉ុប";
    //    for (UIView *view in [cell.contentView subviews]) {
    //        if ([view isEqual:[UIView class]]) {
    //            [view removeFromSuperview];
    //        }
    //    }
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 20;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"index path: %ld",(long)indexPath.row);
}

@end
