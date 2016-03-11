//
//  AddFriendByIDViewController.m
//  KhmerFood
//
//  Created by kvc on 3/9/16.
//  Copyright © 2016 Donut. All rights reserved.
//

#import "AddFriendByIDViewController.h"
#import "IDCustomTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "AppUtils.h"

@interface AddFriendByIDViewController () <UITableViewDataSource,UITextFieldDelegate>
{
    NSMutableArray *arrayResult;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIView *searchNotFoundView;

@end

@implementation AddFriendByIDViewController

#pragma mark : view life cycle

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _myTableView.hidden = true;
    _searchNotFoundView.hidden = true;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = NaviStandartColor;
    [AppUtils settingLeftButton:self action:@selector(leftButtonClicked:) normalImageCode:@"x_button" highlightImageCode:nil];
    arrayResult = [[NSMutableArray alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark : uitableview datasource and delegate methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrayResult count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IDCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.profileName.text = [[arrayResult objectAtIndex:indexPath.row] objectForKey:@"FULL_NAME"];
    if ([AppUtils isNull:[[arrayResult objectAtIndex:indexPath.row] objectForKey:@"USER_ID"]] == false) {
        cell.profileID.text = [[arrayResult objectAtIndex:indexPath.row] objectForKey:@"USER_ID"];
    } else {
//        cell.profileID.text = @"គ្មានអាយឌី";
    }
    
    NSLog(@"profile image url : %@",[[arrayResult objectAtIndex:indexPath.row] objectForKey:@"USER_IMG"]);
    
    [cell.profileImage sd_setImageWithURL:[NSURL URLWithString:[[arrayResult objectAtIndex:indexPath.row] objectForKey:@"USER_IMG"]]];
    
    return cell;
}

#pragma mark : buttons action
-(void)leftButtonClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)searchButton:(UIButton *)sender {
    
    [self requestToServer:@"KF_SFRI"];
    
}

#pragma mark : text field delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.text.length <= 0) {
        [self showTableView:false];
    } else {
        [self requestToServer:@"KF_SFRI"];
    }
    
    [textField resignFirstResponder];
    return true;
}

#pragma mark : request and response

-(void)requestToServer : (NSString *)apiKey {
    [AppUtils showWaitingActivity:self.view];
    NSDictionary *dicData = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"login_data"]];
    NSMutableDictionary *reqDic = [[NSMutableDictionary alloc] init];
    if ([apiKey isEqualToString:@"KF_SFRI"]) {
        NSDictionary *data = @{@"SEARCH_TEXT" : _searchTextField.text,
                                  @"USER_ID":[dicData objectForKey:@"user_id"]};
        [reqDic setObject:data forKey:@"REQ_DATA"];
        [reqDic setObject:apiKey forKey:@"API_KEY"];
    }
    
    [super sendTranData:reqDic];
    
}

-(void)returnTransaction:(NSDictionary *)transaction {
    dispatch_async(dispatch_get_main_queue(), ^{
       [AppUtils hideWaitingActivity];
        self.view.userInteractionEnabled = true;
    });
    
    if ([[transaction objectForKey:@"COUNT"] intValue] != 0) {
        arrayResult = [[NSMutableArray alloc] initWithArray:[transaction objectForKey:@"RESP_DATA"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myTableView reloadData];
            [self showTableView:true];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showTableView:false];
        });
    }
    
}

#pragma mark : show and hide

-(void)showTableView:(BOOL)show {
    if (show) {
        self.myTableView.hidden = false;
        self.searchNotFoundView.hidden = show;
    } else {
        self.myTableView.hidden = true;
        self.searchNotFoundView.hidden = show;
    }
}

@end
