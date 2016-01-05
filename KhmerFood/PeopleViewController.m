//
//  PeopleViewController.m
//  KhmerFood
//
//  Created by kvc on 12/24/15.
//  Copyright © 2015 Donut. All rights reserved.
//

#import "PeopleViewController.h"
#import "CustomPeopleTableViewCell.h"
#import "UINavigationBar+Awesome.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>
#import "FHSStream.h"
#import "FHSTwitterEngine.h"
@interface PeopleViewController () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *coverView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *registerButton;

@end

@implementation PeopleViewController

#pragma mark : View life cycle

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"login_data"] != nil) {
        [self closeCoverView];
    } else {
        [self setupRegisterView];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = NaviStandartColor;
    
    [self setupSearch];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark : other methods

-(void)loginWithFacebookAction {
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    loginManager.loginBehavior = FBSDKLoginBehaviorWeb;
    [loginManager logInWithReadPermissions:@[@"public_profile"] fromViewController:self
                                   handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                       if (error) {
                                           NSLog(@"error : %@",[error localizedDescription]);
                                       } else if ([result isCancelled]) {
                                           NSLog(@"Cancelled");
                                       } else {
                                           NSLog(@"Logged in");
                                           if ([result.grantedPermissions containsObject:@"public_profile"]) {
                                               if ([FBSDKAccessToken currentAccessToken]) {
                                                   NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
                                                   [parameters setValue:@"gender,last_name,first_name,name,picture.type(large)" forKey:@"fields"];
                                                   
                                                   [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
                                                    startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                                                        if (!error)
                                                        {
                                                            
                                                            NSString *name = [[result valueForKey:@"name"] lowercaseString];
                                                            NSString *last_name = [[result valueForKey:@"last_name"] lowercaseString];
                                                            NSString *first_name = [[result valueForKey:@"first_name"] lowercaseString];
                                                            NSString *gender = [[result valueForKey:@"gender"] lowercaseString];
                                                            NSString *username = [name stringByReplacingOccurrencesOfString:@" " withString:@" "];
                                                            NSArray *picture_arr = [result objectForKey:@"picture"];
                                                            NSArray *data_arr = [picture_arr valueForKey:@"data"];
                                                            NSString *profile_pic = [data_arr valueForKey:@"url"];
                                                            
                                                            
                                                            NSLog(@"Gender is : %@",gender);
                                                            NSLog(@"First name is : %@",first_name);
                                                            NSLog(@"Last name is : %@",last_name);
                                                            
                                                            NSDictionary *dicData = @{@"user_name":username,@"profile_pic":profile_pic,@"login_type":@"facebook"};
                                                            NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:dicData];
                                                            [[NSUserDefaults standardUserDefaults] setObject:myData forKey:@"login_data"];
                                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                                            [self closeCoverView];
                                                        }
                                                    }];
                                               }
                                           }
                                       }
                                   }];
}

-(void)loginWithTwitter {
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            NSLog(@"signed in as %@", [session userID]);
            [[[Twitter sharedInstance] APIClient] loadUserWithID:[session userID]
                                                      completion:^(TWTRUser *user,
                                                                   NSError *error) {
                 // handle the response or error
                 if (![error isEqual:nil]) {
                     NSLog(@"Twitter info   -> user = %@ ",user.name);
                     
                     NSString *urlString = [[NSString alloc]initWithString:user.profileImageLargeURL];
                     NSURL *urlImg = [[NSURL alloc]initWithString:urlString];
                     
                     NSDictionary *dicData = @{@"user_name":[session userName],@"profile_pic":urlImg,@"login_type":@"Twitter"};
                     
                     NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:dicData];
                     
                     [[NSUserDefaults standardUserDefaults] setObject:myData forKey:@"login_data"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                     [self closeCoverView];
                     
                 } else {
                     NSLog(@"Twitter error getting profile : %@", [error localizedDescription]);
                 }
             }];
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
            [[FHSTwitterEngine sharedEngine] permanentlySetConsumerKey:@"LGXCB8LxuP4c5OkHwVeKhqobp" andSecret:@"kUIbMY36eaRoYTCRfuMzHWYMuWlKDyhLSqFns340DM53lsNcb0"];
        }
    }];
    
    
    
}

-(void) loginMethodAction:(UIButton *)sender {
    if (sender.tag == 2000) {
        // login with facebook
        [self loginWithFacebookAction];
    } else if (sender.tag == 2001) {
        [self loginWithTwitter];
    }
}

-(void)setupRegisterView {
    
    for (int i = 0; i < 3; i++) {
        [[[_registerButton objectAtIndex:i] layer]setBorderWidth:1.0];
        [[[_registerButton objectAtIndex:i] layer]setBorderColor:[[UIColor whiteColor]CGColor]];
        [[_registerButton objectAtIndex:i] setTag:2000 + i];
        [[_registerButton objectAtIndex:i] addTarget:self action:@selector(registerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.coverView.frame = self.view.frame;
    [self.view addSubview:self.coverView];
    [self.view bringSubviewToFront:self.coverView];
    self.coverView.hidden = false;
    self.tableView.hidden = true;
    
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationItem.titleView = nil;
}

-(void)setupSearch {

    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    searchBar.placeholder = @"ស្វែងរក";
    [searchBar sizeToFit];
    self.tableView.tableHeaderView = searchBar;
    
}

-(void)registerButtonClick:(UIButton *)sender {
    
    [self loginMethodAction:sender];
    
}

-(void)closeCoverView {
        
        [self.navigationController.navigationBar lt_reset];
        UILabel *titleLable =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
        [titleLable setFont:[UIFont systemFontOfSize:17]];
        titleLable.textColor = [UIColor whiteColor];
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.text = @"អំពីខ្ញុំ";
        self.navigationItem.titleView = titleLable;
        
        //    [self.coverView removeFromSuperview];
        self.tableView.hidden = false;
        self.coverView.hidden = true;
        [self.tableView reloadData];
}


#pragma mark : table view method

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CustomPeopleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"login_data"] != nil) {
                NSDictionary *dicData = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"login_data"]];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    // retrive image on global queue
       
                    UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dicData objectForKey:@"profile_pic"]]]]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.myImage.image = img;
                    });
                });
                
                return cell;
            }
        }
    } else if (indexPath.section == 1) {
        cell.myImage.image = [UIImage imageNamed:@"face.png"];
    }
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
