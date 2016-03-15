//
//  NotificationViewController.m
//  KhmerFood
//
//  Created by kvc on 3/10/16.
//  Copyright © 2016 Donut. All rights reserved.
//

#import "NotificationViewController.h"
#import "AppUtils.h"
#import "NotificationCustomTableViewCell.h"


@interface NotificationViewController () <UITableViewDataSource>
{
    BOOL isFriend;
    NSMutableArray *pendingFriendList;
}
@property (weak, nonatomic) IBOutlet UIButton *foodButton;
@property (weak, nonatomic) IBOutlet UIButton *friendButton;
@property (weak, nonatomic) IBOutlet UIImageView *line1;
@property (weak, nonatomic) IBOutlet UIImageView *line2;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;


@end

@implementation NotificationViewController

#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = NaviStandartColor;
    isFriend = false;
    pendingFriendList = [[NSMutableArray alloc] init];
    self.view.tag = 1111111;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)closeWatiing{
}

#pragma mark - buttons action
- (IBAction)sharedButtonAction:(UIButton *)sender {
    
    switch (sender.tag) {
        case 70:
            if (sender.selected == false) {
                sender.selected = true;
                _line1.backgroundColor = NaviStandartColor;
                _line2.backgroundColor = [UIColor lightGrayColor];
                _friendButton.selected = false;
                isFriend = false;
            }
            break;
            
        default:
            [AppUtils showWaitingActivity:self.view];
            if (sender.selected == false) {
                isFriend = true;
                sender.selected = true;
                _line1.backgroundColor = [UIColor lightGrayColor];
                _line2.backgroundColor = NaviStandartColor;
                _foodButton.selected = false;
            }
            
            [self requestToServer:@"KF_LSTPFRND"];
            
            break;
    }
}

#pragma mark : tableview datasource and delegate methods
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NotificationCustomTableViewCell *cell = nil;
    
    if ([pendingFriendList count] != 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellFriend" forIndexPath:indexPath];
        cell.userName.text = [[pendingFriendList objectAtIndex:indexPath.row] objectForKey:@"FULL_NAME"];
        cell.status.text = @"ចង់ក្លាយជាមិត្តរបស់អ្នក";
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellFood" forIndexPath:indexPath];
    }
    
    return cell;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([pendingFriendList count] != 0) {
        return [pendingFriendList count];
    }
    return [pendingFriendList count];
}

#pragma mark - request and response

-(void)requestToServer:(NSString *)apiKey {
    NSMutableDictionary *reqDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    if ([apiKey isEqualToString:@"KF_LSTPFRND"]) {
        NSDictionary *dicData = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"login_data"]];
        [dataDic setObject:[dicData objectForKey:@"user_id"] forKey:@"USER_ID"];
    }
    [reqDic setObject:apiKey forKey:@"API_KEY"];
    [reqDic setObject:dataDic forKey:@"REQ_DATA"];
    NSLog(@"request dic is : %@",reqDic);
    [super sendTranData:reqDic];
}

-(void)returnTransaction:(NSDictionary *)transaction {
    NSLog(@"transcation : %@",transaction);
    dispatch_async(dispatch_get_main_queue(), ^{
        [AppUtils hideWaitingActivity];
        self.view.userInteractionEnabled = true;
    });
    
    if ([AppUtils isNull:transaction] == false) {
        if ([[transaction objectForKey:@"COUNT"] integerValue] != 0) {
            [pendingFriendList addObjectsFromArray:[transaction objectForKey:@"RESP_DATA"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_myTableView reloadData];
            });
            
        }
    }
    
    
}

@end
