//
//  IDCustomTableViewCell.h
//  KhmerFood
//
//  Created by kvc on 3/9/16.
//  Copyright © 2016 Donut. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDCustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *profileName;
@property (weak, nonatomic) IBOutlet UILabel *profileID;
@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;

@end
