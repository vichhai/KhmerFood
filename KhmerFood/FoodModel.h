//
//  FoodModel.h
//  KhmerFood
//
//  Created by kvc on 2/23/16.
//  Copyright © 2016 Donut. All rights reserved.
//

#import <Realm/Realm.h>

@interface FoodModel : RLMObject

@property NSData *foodRecord;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<FoodModel>
RLM_ARRAY_TYPE(FoodModel)
