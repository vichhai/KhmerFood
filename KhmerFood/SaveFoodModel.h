//
//  SaveFoodModel.h
//  KhmerFood
//
//  Created by kvc on 2/25/16.
//  Copyright © 2016 Donut. All rights reserved.
//

#import <Realm/Realm.h>

@interface SaveFoodModel : RLMObject

@property NSString *foodID;
@property NSString *foodName;
@property NSString *foodDetail;
@property NSString *foodCookTime;
@property NSString *foodImage;
@property NSString *foodRate;
@property NSString *foodType;
@property NSString *foodTimeWatch;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<SaveFoodModel>
RLM_ARRAY_TYPE(SaveFoodModel)
