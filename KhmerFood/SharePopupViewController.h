//
//  SharePopupViewController.h
//  KhmerFood
//
//  Created by kvc on 3/3/16.
//  Copyright © 2016 Donut. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SharePopupDelegate;

@interface SharePopupViewController : UIViewController

@property (assign,nonatomic) id <SharePopupDelegate>delegate;

@end

@protocol SharePopupDelegate <NSObject>

@optional
-(void)closeButtonClicked:(SharePopupViewController *)sharePopupViewController;
-(void)shareToFaceBookClicked:(SharePopupViewController *)sharePopupViewController;
-(void)shareToTwitterClicked:(SharePopupViewController *)sharePopupViewController;
-(void)shareToLineClicked:(SharePopupViewController *)sharePopupViewController;
-(void)shareToFriendClicked:(SharePopupViewController *)sharePopupViewController;
@end