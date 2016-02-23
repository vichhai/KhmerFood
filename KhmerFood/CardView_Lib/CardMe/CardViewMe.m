//
//  CardViewMe.m
//  KhmerFood
//
//  Created by Yoman on 12/23/15.
//  Copyright © 2015 Donut. All rights reserved.
//


#import "CardViewMe.h"

@implementation CardViewMe

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    _imageView = [[UIImageView alloc]init];
    _imageView.backgroundColor = [UIColor orangeColor];
    
    _imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 0.75);
    [self addSubview:_imageView];
    
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:_imageView.bounds
                                     byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                           cornerRadii:CGSizeMake(7.0, 7.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _imageView.bounds;
    maskLayer.path = maskPath.CGPath;
    _imageView.layer.mask = maskLayer;
    
    _selectedView = [[UIView alloc]init];
    _selectedView.frame = _imageView.frame;
    _selectedView.backgroundColor = [UIColor clearColor];
    _selectedView.alpha = 0.0;
    [_imageView addSubview:_selectedView];
    
    _label = [[UILabel alloc]init];
    _label.backgroundColor = [UIColor clearColor];
    _label.frame = CGRectMake(10, self.frame.size.height * 0.73, self.frame.size.width - 20, self.frame.size.height * 0.2);
    _label.font = [UIFont fontWithName:@"Futura-Medium" size:14];
    [self addSubview:_label];
    
    _labelName = [[UILabel alloc]init];
    _labelName.backgroundColor = [UIColor clearColor];
    _labelName.frame = CGRectMake(10, self.frame.size.height * 0.8, self.frame.size.width - 20, self.frame.size.height * 0.2);
    _labelName.font = [UIFont fontWithName:@"Futura-Medium" size:14];
    [self addSubview:_labelName];
}

@end

