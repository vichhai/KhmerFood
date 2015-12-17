//
//  HomeCustomTableViewCell.m
//  KhmerFood
//
//  Created by kvc on 12/17/15.
//  Copyright © 2015 Donut. All rights reserved.
//

#import "HomeCustomTableViewCell.h"
#import "CustomCollectionViewCell.h"
@implementation HomeCustomTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
