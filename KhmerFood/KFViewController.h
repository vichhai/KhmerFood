//
//  KFViewController.h
//  KhmerFood
//
//  Created by kvc on 12/1/15.
//  Copyright © 2015 Donut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionManager.h"
#import "AppUtils.h"
@interface KFViewController : UIViewController<ConnectionManagerDelegate>

-(void)sendTranData:(NSDictionary *)requestDic;
-(void)returnTransaction:(NSDictionary *)transaction;

@end
