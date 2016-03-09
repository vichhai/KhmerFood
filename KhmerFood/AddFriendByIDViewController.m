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

@interface AddFriendByIDViewController () <UITableViewDataSource,UITextFieldDelegate>
{
    NSMutableArray *arrayResult;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@end

@implementation AddFriendByIDViewController

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
    [textField resignFirstResponder];
    [self requestToServer:@"KF_SFRI"];
    return true;
}

#pragma mark : request and response

-(void)requestToServer : (NSString *)apiKey {
    
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
    
    if ([AppUtils isNull:[transaction objectForKey:@"RESP_DATA"]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            arrayResult = [[NSMutableArray alloc] initWithArray:[transaction objectForKey:@"RESP_DATA"]];
            [self.myTableView reloadData];
        });
    }
    
}

@end
