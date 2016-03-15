//
//  NotificationCustomTableViewCell.h
//  KhmerFood
//
//  Created by kvc on 3/11/16.
//  Copyright © 2016 Donut. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationCustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *cancleButton;

@end
