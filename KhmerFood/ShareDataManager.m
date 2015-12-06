//
//  ShareObjectManager.m
//  KhmerFood
//
//  Created by kvc on 12/1/15.
//  Copyright © 2015 Donut. All rights reserved.
//

#import "ShareDataManager.h"

static ShareDataManager *shareData = nil;

@implementation ShareDataManager

+(ShareDataManager *)shareDataManager {
    if (shareData == nil) {
        shareData = [[ShareDataManager alloc] init];
    }
    return shareData;
}

@end
