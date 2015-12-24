//
//  NameSettingTableViewController.m
//  KhmerFood
//
//  Created by kvc on 12/24/15.
//  Copyright © 2015 Donut. All rights reserved.
//

#import "NameSettingTableViewController.h"
#import "AppUtils.h"

@interface NameSettingTableViewController ()

@end

@implementation NameSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:45/255.0 green:169/255.0 blue:122/255.0 alpha:1]];
    
    UILabel *titleLable =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
    [titleLable setFont:[UIFont systemFontOfSize:17]];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.text = @"គណនេយ្យ";
    self.navigationItem.titleView = titleLable;
    
    [AppUtils settingLeftButton:self action:@selector(leftButtonClicked:) normalImageCode:@"go_back" highlightImageCode:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark : table view methods
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    view.backgroundColor = [UIColor lightGrayColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, tableView.frame.size.width - 20, 10)];
    [label setFont:[UIFont systemFontOfSize:10]];
    [label setTextColor:[UIColor blackColor]];
    [view addSubview:label];
    
    label.text = @"ផ្លាស់ប្ដូរឈ្មោះ";
    
    return view;
}


#pragma mark : button aciton
-(void)leftButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
}




@end
