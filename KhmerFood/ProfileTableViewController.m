//
//  ProfileTableViewController.m
//  KhmerFood
//
//  Created by kvc on 12/23/15.
//  Copyright © 2015 Donut. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "AppUtils.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface ProfileTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *connectionType;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong,nonatomic) ACAccountStore *account;
@end

@implementation ProfileTableViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"login_data"] != nil) {
        
        NSDictionary *dicData = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"login_data"]];
        
        _userName.text = [dicData objectForKey:@"user_name"];
        _connectionType.text = [NSString stringWithFormat:@"កំពុងភ្ជាប់ជាមួយ %@",[dicData objectForKey:@"login_type"]];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // retrive image on global queue
            NSLog(@"string url: %@",[dicData objectForKey:@"profile_pic"]);
            UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dicData objectForKey:@"profile_pic"]]]]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _profileImage.image = img;
            });
        });
        
        
        
        
    }
    
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
- (IBAction)logout:(UIButton *)sender {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"login_data"] != nil) {
        NSDictionary *dicData = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"login_data"]];
        if ([[dicData objectForKey:@"login_type"] isEqualToString:@"facebook"]) {
            [FBSDKAccessToken setCurrentAccessToken:nil];
            [FBSDKProfile setCurrentProfile:nil];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"login_data"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self dismissViewControllerAnimated:true completion:nil];
        } else {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"login_data"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }
}

#pragma mark - other methods
-(void)otherMethod {
  
}


@end
