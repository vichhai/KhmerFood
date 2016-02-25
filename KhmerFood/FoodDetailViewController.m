//
//  FoodDetailViewController.m
//  KhmerFood
//
//  Created by kvc on 12/22/15.
//  Copyright © 2015 Donut. All rights reserved.
//

#import "FoodDetailViewController.h"
#import "AppUtils.h"
#import "CustomFoodDetailTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "SaveFoodModel.h"

#define NAVBAR_CHANGE_POINT 0
@interface FoodDetailViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UILabel *titleLable;
    CGFloat height;
}

@property (weak, nonatomic) IBOutlet UIImageView *foodImage;
@property (weak, nonatomic) IBOutlet UILabel *foodName;
@property (weak, nonatomic) IBOutlet UILabel *foodType;

@end

@implementation FoodDetailViewController

#pragma mark - view life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [AppUtils settingLeftButton:self action:@selector(lettButtonClicked:) normalImageCode:@"go_back.png" highlightImageCode:nil];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self setupNavigationRightButtons];
    
    titleLable =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 25)];
    [titleLable setFont:[UIFont systemFontOfSize:17]];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.textAlignment = NSTextAlignmentCenter;
    
    
    if ([AppUtils isNull:[_receiveData objectForKey:@"FD_IMG"]] == false) {
        [_foodImage sd_setImageWithURL:[NSURL URLWithString:[_receiveData objectForKey:@"FD_IMG"]]];
    } else {
        _foodImage.image = [UIImage imageNamed:@"no_image.jpeg"];
    }
    _foodName.text = [_receiveData objectForKey:@"FD_NAME"];
    _foodType.text = [_receiveData objectForKey:@"FD_NAME"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self scrollViewDidScroll:self.tableView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar lt_reset];
}

#pragma mark - set up navigation button

-(void)setupNavigationRightButtons {
    
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 20.0f)];
    [shareButton setImage:[UIImage imageNamed:@"upload.png"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(btnShareClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 20.0f)];
    [saveButton setImage:[UIImage imageNamed:@"pin.png"] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(btnSaveClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    
    NSArray *barButtonItemArray = [[NSArray alloc] initWithObjects:barButtonItem2, barButtonItem1, nil];
    
    self.navigationItem.rightBarButtonItems = barButtonItemArray;
    
    
}

#pragma mark - tableview datasource method

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomFoodDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    height = [AppUtils measureTextHeight:[_receiveData objectForKey:@"FD_DETAIL"] constrainedToSize:CGSizeMake(cell.contentView.frame.size.width, 2000.0f) fontSize:15.0f] * 1.2;
    NSLog(@"=====> %f",height);
    if (height > 1400) {
        height = height + 150;
    } else if (height <= 1096) {
        height = height - 100;
    }
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(8, 8, cell.contentView.frame.size.width - 16,height)];
    webView.scrollView.scrollEnabled = false;
    [webView loadHTMLString:[_receiveData objectForKey:@"FD_DETAIL"] baseURL:nil];
    [cell.contentView addSubview:webView];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return height + 16;
}

#pragma mark - scrollview delegate method

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIColor * color = [UIColor colorWithRed:53/255.0 green:201/255.0 blue:147/255.0 alpha:1];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        titleLable.text = [_receiveData objectForKey:@"FD_NAME"];
        self.navigationItem.titleView = titleLable;
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        titleLable.text = nil;
        self.navigationItem.titleView = titleLable;
    }
}

#pragma mark - buttons methods

-(void)btnSaveClicked:(UIButton *)sender {
    [self checkAndSave:[_receiveData objectForKey:@"FD_NAME"]];
}

-(void)btnShareClicked:(UIButton *)sender {
    NSLog(@"share button work");
}

-(void)lettButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - check and save

-(void)checkAndSave:(NSString *)foodName {
    
    RLMResults<SaveFoodModel *> *saveFoods = [AppUtils readObjectFromRealm:[[SaveFoodModel alloc] init]];
    BOOL isHave = false;
    for (int i = 0 ; i < [saveFoods count]; i++) {
        SaveFoodModel *obj = [saveFoods objectAtIndex:i];
        if ([obj.foodName isEqualToString:foodName]) {
            isHave = true;
            break;
        }
    }
    
    if (isHave == false) {
        SaveFoodModel *saveObject = [[SaveFoodModel alloc] init];
        
        if ([AppUtils isNull: [_receiveData objectForKey:@"FD_ID"]] == false) {
            saveObject.foodID = [_receiveData objectForKey:@"FD_ID"];
        } else {
            saveObject.foodID = @"";
        }
        
        if ([AppUtils isNull: [_receiveData objectForKey:@"FD_NAME"]] == false) {
            saveObject.foodName = [_receiveData objectForKey:@"FD_NAME"];
        } else {
            saveObject.foodName = @"";
        }
        
        if ([AppUtils isNull: [_receiveData objectForKey:@"FD_DETAIL"]] == false) {
            saveObject.foodDetail = [_receiveData objectForKey:@"FD_DETAIL"];
        } else {
            saveObject.foodDetail = @"";
        }
        
        if ([AppUtils isNull: [_receiveData objectForKey:@"FD_COOK_TIME"]] == false) {
            saveObject.foodCookTime = [_receiveData objectForKey:@"FD_COOK_TIME"];
        } else {
            saveObject.foodCookTime = @"";
        }
        
        if ([AppUtils isNull: [_receiveData objectForKey:@"FD_IMG"]] == false) {
            saveObject.foodImage = [_receiveData objectForKey:@"FD_IMG"];
        } else {
            saveObject.foodImage = @"";
        }
        
        if ([AppUtils isNull: [_receiveData objectForKey:@"FD_RATE"]] == false) {
            saveObject.foodRate = [_receiveData objectForKey:@"FD_RATE"];
        } else {
            saveObject.foodRate = @"";
        }
        
        if ([AppUtils isNull: [_receiveData objectForKey:@"FD_TYPE"]] == false) {
            saveObject.foodType = [_receiveData objectForKey:@"FD_TYPE"];
        } else {
            saveObject.foodType = @"";
        }
        
        if ([AppUtils isNull: [_receiveData objectForKey:@"FD_TIME_WATCH"]] == false) {
            saveObject.foodTimeWatch = [_receiveData objectForKey:@"FD_TIME_WATCH"];
        } else {
            saveObject.foodTimeWatch = @"";
        }
        
        [AppUtils writeObjectToRealm:saveObject];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"ម្ហូបនេះបានរក្សាទុករួចម្ដងហើយ" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"យល់ព្រម" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:true completion:nil];
    }
}

@end
