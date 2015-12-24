//
//  PeopleViewController.m
//  KhmerFood
//
//  Created by kvc on 12/24/15.
//  Copyright © 2015 Donut. All rights reserved.
//

#import "PeopleViewController.h"
#import "CustomPeopleTableViewCell.h"

@interface PeopleViewController () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PeopleViewController

#pragma mark : View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:45/255.0 green:169/255.0 blue:122/255.0 alpha:1]];
    
    UILabel *titleLable =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
    [titleLable setFont:[UIFont systemFontOfSize:17]];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.text = @"អំពីខ្ញុំ";
    self.navigationItem.titleView = titleLable;
    
    [self setupSearch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark : other methods
-(void)setupSearch {

    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    searchBar.placeholder = @"ស្វែងរក";
    [searchBar sizeToFit];
    self.tableView.tableHeaderView = searchBar;
    
}

#pragma mark : table view method

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CustomPeopleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    return cell;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 10;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    view.backgroundColor = [UIColor lightGrayColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, tableView.frame.size.width - 20, 30)];
    [label setFont:[UIFont systemFontOfSize:17]];
    [label setTextColor:[UIColor blackColor]];
    [view addSubview:label];
    
    if (section == 0) {
        label.text = @"អំពីខ្ញុំ";
    } else {
        label.text = @"មិត្តរបស់ខ្ញុំ";
    }
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self performSegueWithIdentifier:@"viewProfile" sender:nil];
        }
    }
    
}

@end
