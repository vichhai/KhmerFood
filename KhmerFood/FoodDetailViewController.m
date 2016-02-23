//
//  FoodDetailViewController.m
//  KhmerFood
//
//  Created by kvc on 12/22/15.
//  Copyright © 2015 Donut. All rights reserved.
//

#import "FoodDetailViewController.h"
#import "AppUtils.h"
#import "CustomFoodDetailTableViewCell.h"
#import "UIImageView+WebCache.h"

#define NAVBAR_CHANGE_POINT 0
@interface FoodDetailViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UILabel *titleLable;
}

@property (weak, nonatomic) IBOutlet UIImageView *foodImage;
@property (weak, nonatomic) IBOutlet UILabel *foodName;
@property (weak, nonatomic) IBOutlet UILabel *foodType;

@end

@implementation FoodDetailViewController

#pragma mark - view life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [AppUtils settingLeftButton:self action:@selector(lettButtonClicked:) normalImageCode:@"go_back.png" highlightImageCode:nil];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self setupNavigationRightButtons];
    
    titleLable =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
    [titleLable setFont:[UIFont systemFontOfSize:17]];
    titleLable.textColor = [UIColor whiteColor];
    
    [_foodImage sd_setImageWithURL:[NSURL URLWithString:[_receiveData objectForKey:@"FD_IMG"]]];
    _foodName.text = [_receiveData objectForKey:@"FD_NAME"];
    _foodType.text = [_receiveData objectForKey:@"FD_NAME"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self scrollViewDidScroll:self.tableView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.navigationController.navigationBar.translucent = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - set up navigation button

-(void)setupNavigationRightButtons {
    
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 20.0f)];
    [shareButton setImage:[UIImage imageNamed:@"upload.png"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(btnShareClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 20.0f)];
    [saveButton setImage:[UIImage imageNamed:@"pin.png"] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(btnSaveClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    
    NSArray *barButtonItemArray = [[NSArray alloc] initWithObjects:barButtonItem2, barButtonItem1, nil];
    
    self.navigationItem.rightBarButtonItems = barButtonItemArray;
    
    
}

#pragma mark - tableview datasource method

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomFoodDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [cell.myWebView loadHTMLString:[_receiveData objectForKey:@"FD_DETAIL"] baseURL:nil];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark - scrollview delegate method

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIColor * color = [UIColor colorWithRed:53/255.0 green:201/255.0 blue:147/255.0 alpha:1];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        titleLable.text = [_receiveData objectForKey:@"FD_NAME"];;
        self.navigationItem.titleView = titleLable;
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        titleLable.text = nil;
        self.navigationItem.titleView = titleLable;
    }
}

#pragma mark - buttons methods

-(void)btnSaveClicked:(UIButton *)sender {
    NSLog(@"save button work");
}

-(void)btnShareClicked:(UIButton *)sender {
    NSLog(@"share button work");
}

-(void)lettButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
}


@end
