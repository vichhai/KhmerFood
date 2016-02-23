//
//  CardViewMe.h
//  KhmerFood
//
//  Created by Yoman on 12/23/15.
//  Copyright © 2015 Donut. All rights reserved.
//
    

#import <UIKit/UIKit.h>
#import "YSLCardView.h"

@interface CardViewMe : YSLCardView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *labelName;
@property (nonatomic, strong) UIView *selectedView;

@end
