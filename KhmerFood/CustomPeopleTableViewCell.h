//
//  CustomPeopleTableViewCell.h
//  KhmerFood
//
//  Created by kvc on 12/24/15.
//  Copyright © 2015 Donut. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomPeopleTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *profileName;
@property (weak, nonatomic) IBOutlet UILabel *profileDetail;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end
