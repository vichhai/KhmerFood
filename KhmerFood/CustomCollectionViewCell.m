//
//  CustomCollectionViewCell.m
//  KhmerFood
//
//  Created by kvc on 12/17/15.
//  Copyright © 2015 Donut. All rights reserved.
//

#import "CustomCollectionViewCell.h"

@implementation CustomCollectionViewCell

-(void)awakeFromNib{
    // border
    [self.containView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
//    [self.containView.layer setBorderWidth:1.5f];
    
    // drop shadow
    [self.containView.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.containView.layer setShadowOpacity:0.8];
    [self.containView.layer setShadowRadius:3.0];
    [self.containView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
}

@end
