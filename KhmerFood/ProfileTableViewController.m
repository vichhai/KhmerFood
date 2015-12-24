//
//  ProfileTableViewController.m
//  KhmerFood
//
//  Created by kvc on 12/23/15.
//  Copyright © 2015 Donut. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "AppUtils.h"
@interface ProfileTableViewController ()

@end

@implementation ProfileTableViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [AppUtils settingLeftButton:self action:@selector(leftButtonClicked:) normalImageCode:@"x_button" highlightImageCode:nil];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.navigationController.navigationBar.translucent = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark : button aciton
-(void)leftButtonClicked:(UIButton *)sender {
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
}
@end
