//
//  ShareObjectManager.h
//  KhmerFood
//
//  Created by kvc on 12/1/15.
//  Copyright © 2015 Donut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ShareDataManager : NSObject

+(ShareDataManager *)shareDataManager;

@property (strong,nonatomic) UIImage *shareImage;


@end
