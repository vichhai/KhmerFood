//
//  AllFoodModel.h
//  KhmerFood
//
//  Created by kvc on 2/24/16.
//  Copyright © 2016 Donut. All rights reserved.
//

#import <Realm/Realm.h>

@interface AllFoodModel : RLMObject

@property NSData *allFoods;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<AllFoodModel>
RLM_ARRAY_TYPE(AllFoodModel)
