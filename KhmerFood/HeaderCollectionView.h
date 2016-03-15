//
//  HeaderCollectionView.h
//  KhmerFood
//
//  Created by kvc on 3/15/16.
//  Copyright © 2016 Donut. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderCollectionView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *friendName;
@property (weak, nonatomic) IBOutlet UILabel *friendID;
@property (weak, nonatomic) IBOutlet UILabel *friendsOfFriend;
@property (weak, nonatomic) IBOutlet UILabel *foodsOfFriend;
@property (weak, nonatomic) IBOutlet UIImageView *friendProfilePicture;

@end
