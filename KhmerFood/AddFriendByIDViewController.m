//
//  AddFriendByIDViewController.m
//  KhmerFood
//
//  Created by kvc on 3/9/16.
//  Copyright © 2016 Donut. All rights reserved.
//

#import "AddFriendByIDViewController.h"
#import "IDCustomTableViewCell.h"

@interface AddFriendByIDViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation AddFriendByIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = NaviStandartColor;
    [AppUtils settingLeftButton:self action:@selector(leftButtonClicked:) normalImageCode:@"x_button" highlightImageCode:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark : uitableview datasource and delegate methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IDCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    return cell;
}

#pragma mark : buttons action
-(void)leftButtonClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
