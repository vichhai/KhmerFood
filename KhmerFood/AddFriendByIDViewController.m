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
    int index;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIView *searchNotFoundView;

@end

@implementation AddFriendByIDViewController

#pragma mark - view life cycle

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

#pragma mark - uitableview datasource and delegate methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrayResult count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IDCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.profileName.text = [[arrayResult objectAtIndex:indexPath.row] objectForKey:@"FULL_NAME"];
    
    if ([AppUtils isNull:[[arrayResult objectAtIndex:indexPath.row] objectForKey:@"USER_ID"]] == false) {
        cell.profileID.text = [[arrayResult objectAtIndex:indexPath.row] objectForKey:@"USER_ID"];
    }
    
    if (![AppUtils isNull:[[arrayResult objectAtIndex:indexPath.row] objectForKey:@"USER_IMG"]]) {
        [cell.profileImage sd_setImageWithURL:[NSURL URLWithString:[[arrayResult objectAtIndex:indexPath.row] objectForKey:@"USER_IMG"]]];
    }
    
    [cell.addFriendButton addTarget:self action:@selector(addFriendClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.addFriendButton.tag = indexPath.row + 1;
    
    
    
    return cell;
}

#pragma mark - buttons action
-(void)leftButtonClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)searchButton:(UIButton *)sender {

    [self requestToServer:@"KF_SFRI"];
    
}

-(void)addFriendClicked:(UIButton *)sender {
    index = sender.tag - 1;
    [self requestToServer:@"KF_ADDFRI"];
}

#pragma mark - text field delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.text.length <= 0) {
        [self showTableView:false];
    } else {
        [self requestToServer:@"KF_SFRI"];
    }
    
    [textField resignFirstResponder];
    return true;
}

#pragma mark - request and response

-(void)requestToServer : (NSString *)apiKey {
    [AppUtils showWaitingActivity:self.view];
    NSDictionary *dicData = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"login_data"]];
    NSMutableDictionary *reqDic = [[NSMutableDictionary alloc] init];
    if ([apiKey isEqualToString:@"KF_SFRI"]) {
        NSDictionary *data = @{@"SEARCH_TEXT" : _searchTextField.text,
                                  @"USER_ID":[dicData objectForKey:@"user_id"]};
        [reqDic setObject:data forKey:@"REQ_DATA"];
        [reqDic setObject:apiKey forKey:@"API_KEY"];
    } else if([apiKey isEqualToString:@"KF_ADDFRI"]) {
        NSDictionary *data = nil;
        if ([AppUtils isNull:[[arrayResult objectAtIndex:index] objectForKey:@"USER_ID"]] == true) {
            data = @{@"REP_USR_ID" :@"none" ,
                                   @"USER_ID":[dicData objectForKey:@"user_id"]};
        } else {
            data = @{@"REP_USR_ID" :[[arrayResult objectAtIndex:index] objectForKey:@"USER_ID"] ,
                                   @"USER_ID":[dicData objectForKey:@"user_id"]};
        }
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
        
    if ([[transaction objectForKey:@"API_KEY"] isEqualToString:@"KF_SFRI"]) { // search friend
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
    } else if ([[transaction objectForKey:@"API_KEY"] isEqualToString:@"KF_ADDFRI"]) { // add friend
        if ([[[transaction objectForKey:@"RESP_DATA"] objectForKey:@"STATUS"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
               [AppUtils showErrorMessage:@"ការបន្ថែមមិត្តថ្មីបានជោគជ័យ" anyView:self];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [AppUtils showErrorMessage:@"ការបន្ថែមមិត្តថ្មីបរាជ័យ" anyView:self];
            });
        }
    }
}

#pragma mark - show and hide

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
