//
//  SaveFoodModel.h
//  KhmerFood
//
//  Created by kvc on 2/25/16.
//  Copyright © 2016 Donut. All rights reserved.
//

#import <Realm/Realm.h>

@interface SaveFoodModel : RLMObject

@property NSString *FD_ID;
@property NSString *FD_NAME;
@property NSString *FD_DETAIL;
@property NSString *FD_COOK_TIME;
@property NSString *FD_IMG;
@property NSString *FD_RATE;
@property NSString *FD_TYPE;
@property NSString *FD_TIME_WATCH;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<SaveFoodModel>
RLM_ARRAY_TYPE(SaveFoodModel)
