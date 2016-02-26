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

@synthesize SCheckRealoadSaveFood		    = _SCheckRealoadSaveFood;

+(ShareDataManager *)shareDataManager {
    if (shareData == nil) {
        shareData = [[ShareDataManager alloc] init];
      
    }
    return shareData;
}
- (id)init {
    self = [super init];
    
    if (self != nil) {
        _SCheckRealoadSaveFood = YES;
    }
    
    return self;
}
@end
