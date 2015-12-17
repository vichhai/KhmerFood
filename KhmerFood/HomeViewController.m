//
//  HomeViewController.m
//  KhmerFood
//
//  Created by kvc on 12/2/15.
//  Copyright © 2015 Donut. All rights reserved.
//

#import "HomeViewController.h"
#import "ConnectionManager.h"
#import "HomeCustomTableViewCell.h"
#import "CustomCollectionViewCell.h"
@interface HomeViewController () <UITableViewDataSource,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *homeTableview;

@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    [self requestToserver];
}

-(void)requestToserver{
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]init];
    
    NSDictionary *dic = @{@"USER_ID":@"ee"};
    [dataDic setObject:dic forKey:@"REQ"];
    [dataDic setObject:@"TEST_002" forKey:@"KEY"];
    [super sendTranData:dataDic];
}

-(void)returnTransaction:(NSDictionary *)transaction{
    NSLog(@"Transaction : %@",transaction);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark : - tableview delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.homeLabel.text = @"I want to go back home T_T";
    
    for (UIView *view in [cell.contentView subviews]) {
        if ([view isEqual:[UICollectionView class]]) {
            [view removeFromSuperview];
        }
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

#pragma mark: - collecitonView Delegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.mylabel.text = @"ម្ហូបអាគាំង";
    for (UIView *view in [cell.contentView subviews]) {
        if ([view isEqual:[UIView class]]) {
            [view removeFromSuperview];
        }
    }
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 20;
}
@end
