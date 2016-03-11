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

@property (weak, nonatomic) IBOutlet UIButton *foodButton;
@property (weak, nonatomic) IBOutlet UIButton *friendButton;
@property (weak, nonatomic) IBOutlet UIImageView *line1;
@property (weak, nonatomic) IBOutlet UIImageView *line2;



@end

@implementation NotificationViewController

#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = NaviStandartColor;
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
            }
            break;
            
        default:
            if (sender.selected == false) {
                sender.selected = true;
                _line1.backgroundColor = [UIColor lightGrayColor];
                _line2.backgroundColor = NaviStandartColor;
                _foodButton.selected = false;
            }
            break;
    }
    
}

#pragma mark : tableview datasource and delegate methods



@end
