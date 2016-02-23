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
#import "FirstRowCollectionViewCell.h"
#import "SecondCollectionViewController.h"
#import "ThirdCollectionViewController.h"
#import "UINavigationBar+Awesome.h"
#import <Realm/Realm.h>

@interface HomeViewController : UITableViewController

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTopConstraint;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageButtomConstraint;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionRow1;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionRow2;
@property (weak, nonatomic) IBOutlet UICollectionView *collectinRow3;

@end
