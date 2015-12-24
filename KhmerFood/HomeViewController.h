//
//  HomeViewController.h
//  KhmerFood
//
//  Created by kvc on 12/2/15.
//  Copyright © 2015 Donut. All rights reserved.
//

#import "KFViewController.h"
#import "ConnectionManager.h"
#import "AppUtils.h"
//#import "GKFadeNavigationController.h"
#import "UINavigationBar+Awesome.h"
@interface HomeViewController : UITableViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageButtomConstraint;

@end
