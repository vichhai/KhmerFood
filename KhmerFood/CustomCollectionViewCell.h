//
//  CustomCollectionViewCell.h
//  KhmerFood
//
//  Created by kvc on 12/17/15.
//  Copyright © 2015 Donut. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *myImage;
@property (weak, nonatomic) IBOutlet UILabel *mylabel;
@property (weak, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet UILabel *foodType;

@end
