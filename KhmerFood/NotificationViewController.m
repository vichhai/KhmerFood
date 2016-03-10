//
//  NotificationViewController.m
//  KhmerFood
//
//  Created by kvc on 3/10/16.
//  Copyright © 2016 Donut. All rights reserved.
//

#import "NotificationViewController.h"
#import "AppUtils.h"

@interface NotificationViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *myImage;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [AppUtils showWaitingActivity:self.view];
    
    [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(closeWatiing) userInfo:nil repeats:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)closeWatiing{
    [AppUtils hideWaitingActivity];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
