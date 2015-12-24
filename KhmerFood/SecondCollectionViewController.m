//
//  SecondCollectionViewController.m
//  KhmerFood
//
//  Created by kvc on 12/17/15.
//  Copyright © 2015 Donut. All rights reserved.
//

#import "SecondCollectionViewController.h"
#import "CustomCollectionViewCell.h"

@interface SecondCollectionViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *firstCollectionView;
@end

@implementation SecondCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell1" forIndexPath:indexPath];
    cell.mylabel.text = @"ម្ហូបអាគាំង";
    cell.foodType.text = @"ប្រភេទ អឺរ៉ុប";
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 20;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"index path: %ld",(long)indexPath.row);
}
@end
