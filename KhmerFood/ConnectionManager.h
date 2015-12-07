//
//  ConnectionManager.h
//  KhmerFood
//
//  Created by kvc on 12/1/15.
//  Copyright © 2015 Donut. All rights reserved.
//

#import <Foundation/Foundation.h>

// protocol
@protocol ConnectionManagerDelegate;

// class
@interface ConnectionManager : NSObject <NSURLSessionDataDelegate>

@property (nonatomic,weak) id<ConnectionManagerDelegate>delegate;
-(void)sendTranData:(NSDictionary *)reqDictionary;

@end

// protocol method
@protocol ConnectionManagerDelegate <NSObject>

@required
-(void)returnResult:(NSDictionary *)result;
-(void)returnResultWithData:(NSData *)data;
@end