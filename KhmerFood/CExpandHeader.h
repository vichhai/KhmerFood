//
//  CExpandHeader.h
//  ResolutionexpensesAPP
//
//  Created by Yoman on 12/14/15.
//  Copyright © 2015 yoman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CExpandHeader : NSObject <UIScrollViewDelegate>

+ (id)expandWithScrollView:(UIScrollView*)scrollView expandView:(UIView*)expandView;

- (void)expandWithScrollView:(UIScrollView*)scrollView expandView:(UIView*)expandView;

- (void)scrollViewDidScroll:(UIScrollView*)scrollView;

@end

