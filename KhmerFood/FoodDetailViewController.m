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
#import <Social/Social.h>
#import "SharePopupViewController.h"
#import "UIViewController+MJPopupViewController.h"


#define NAVBAR_CHANGE_POINT 0
@interface FoodDetailViewController () <UITableViewDelegate,UITableViewDataSource,SharePopupDelegate,ConnectionManagerDelegate>
{
    UILabel *titleLable;
    CGFloat height;
    SharePopupViewController *popupView;
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
    [self setupNavigationTitle];
    [self setupTableImageHeader];
    
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

#pragma mark - set up navigation

-(void) setupNavigationTitle {
    titleLable =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 25)];
    [titleLable setFont:[UIFont systemFontOfSize:17]];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.textAlignment = NSTextAlignmentCenter;
}

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
    
    NSLog(@"height %f",height);
    
    if (height > 1400) {
        height = height + 150;
    } else if (height <= 1096) {
        height = height - 50;
    } else if (height > 1200) {
        height = height + 100;
    } else if (height > 1480) {
        height = height + 150;
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
    popupView = nil;
    popupView = [[SharePopupViewController alloc] initWithNibName:@"SharePopupViewController" bundle:nil];
    popupView.delegate = self;
    [self presentPopupViewController:popupView animationType:MJPopupViewAnimationFade contentInteraction:MJPopupViewContentInteractionDismissBackgroundOnly];
}

-(void)lettButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
}

-(void)closeButtonClicked:(SharePopupViewController *)sharePopupViewController {
    [self dismissPopupViewController:sharePopupViewController
                       animationType:MJPopupViewAnimationFade];
    popupView = nil;
    
}

-(void)shareToFaceBookClicked:(SharePopupViewController *)sharePopupViewController {
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *cont = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [cont addImage:[UIImage imageNamed:@"face.png"]];
        [self presentViewController:cont animated:true completion:nil];
    }
    
}

-(void)shareToTwitterClicked:(SharePopupViewController *)sharePopupViewController {
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *cont = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [cont addImage:[UIImage imageNamed:@"face.png"]];
        [self presentViewController:cont animated:true completion:nil];
    }
    
}

-(void)shareToFriendClicked:(SharePopupViewController *)sharePopupViewController {
    

    //=====GO to Share to Friend
    [self performSegueWithIdentifier:@"ShareFIrSegue" sender:nil];
    
    [self dismissPopupViewController:sharePopupViewController animationType:MJPopupViewAnimationFade];
    popupView = nil;
    
}
#pragma mark - check and save

-(void)checkAndSave:(NSString *)foodName {
    
    if ([AppUtils isNull:[[NSUserDefaults standardUserDefaults] objectForKey:@"login_data"]]) {
        [AppUtils showErrorMessage:@"សូមធ្វើការ login ដើម្បីអាចរក្សាមុខម្ហូបបាន" anyView:self];
    } else {
        RLMResults<SaveFoodModel *> *saveFoods = [AppUtils readObjectFromRealm:[[SaveFoodModel alloc] init]];
        BOOL isHave = false;
        for (int i = 0 ; i < [saveFoods count]; i++) {
            SaveFoodModel *obj = [saveFoods objectAtIndex:i];
            if ([obj.FD_NAME isEqualToString:foodName]) {
                isHave = true;
                break;
            }
        }
        
        if (isHave == false) {
            SaveFoodModel *saveObject = [[SaveFoodModel alloc] init];
            
            if ([AppUtils isNull: [_receiveData objectForKey:@"FD_ID"]] == false) {
                saveObject.FD_ID = [_receiveData objectForKey:@"FD_ID"];
            } else {
                saveObject.FD_ID = @"";
            }
            
            if ([AppUtils isNull: [_receiveData objectForKey:@"FD_NAME"]] == false) {
                saveObject.FD_NAME = [_receiveData objectForKey:@"FD_NAME"];
            } else {
                saveObject.FD_NAME = @"";
            }
            
            if ([AppUtils isNull: [_receiveData objectForKey:@"FD_DETAIL"]] == false) {
                saveObject.FD_DETAIL = [_receiveData objectForKey:@"FD_DETAIL"];
            } else {
                saveObject.FD_DETAIL = @"";
            }
            
            if ([AppUtils isNull: [_receiveData objectForKey:@"FD_COOK_TIME"]] == false) {
                saveObject.FD_COOK_TIME = [_receiveData objectForKey:@"FD_COOK_TIME"];
            } else {
                saveObject.FD_COOK_TIME = @"";
            }
            
            if ([AppUtils isNull: [_receiveData objectForKey:@"FD_IMG"]] == false) {
                saveObject.FD_IMG = [_receiveData objectForKey:@"FD_IMG"];
            } else {
                saveObject.FD_IMG = @"";
            }
            
            if ([AppUtils isNull: [_receiveData objectForKey:@"FD_RATE"]] == false) {
                saveObject.FD_RATE = [_receiveData objectForKey:@"FD_RATE"];
            } else {
                saveObject.FD_RATE = @"";
            }
            
            if ([AppUtils isNull: [_receiveData objectForKey:@"FD_TYPE"]] == false) {
                saveObject.FD_TYPE = [_receiveData objectForKey:@"FD_TYPE"];
            } else {
                saveObject.FD_TYPE = @"";
            }
            
            if ([AppUtils isNull: [_receiveData objectForKey:@"FD_TIME_WATCH"]] == false) {
                saveObject.FD_TIME_WATCH = [_receiveData objectForKey:@"FD_TIME_WATCH"];
            } else {
                saveObject.FD_TIME_WATCH = @"";
            }
            
            [AppUtils writeObjectToRealm:saveObject];
            
            ///=====just for checking to reload at Save Food Screen
            [ShareDataManager shareDataManager].SCheckRealoadSaveFood = true;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self requestToServer:@"KF_SAVEFOOD"];
            });
            
            [AppUtils showErrorMessage:@"ម្ហូបត្រូវបានរក្សាទុក" anyView:self];
            
        } else {
            [AppUtils showErrorMessage:@"ម្ហូបនេះបានរក្សាទុករួចម្ដងហើយ" anyView:self];
        }
    }
}

#pragma mark - other methods
-(void)setupTableImageHeader {
    if ([AppUtils isNull:[_receiveData objectForKey:@"FD_IMG"]] == false) {
        [_foodImage sd_setImageWithURL:[NSURL URLWithString:[_receiveData objectForKey:@"FD_IMG"]]];
    } else {
        _foodImage.image = [UIImage imageNamed:@"no_image.jpeg"];
    }
    _foodName.text = [_receiveData objectForKey:@"FD_NAME"];
    _foodType.text = [_receiveData objectForKey:@"FD_NAME"];
}

#pragma mark - request and response
-(void)requestToServer:(NSString *)apiKey {
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    if ([apiKey isEqualToString:@"KF_SAVEFOOD"]) {
        NSDictionary *dicData = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"login_data"]];
        [dataDic setObject:[dicData objectForKey:@"user_id"] forKey:@"USER_ID"];
        if ([AppUtils isNull: [_receiveData objectForKey:@"FD_ID"]] == false) {
            [dataDic setObject:[_receiveData objectForKey:@"FD_ID"] forKey:@"FD_ID"];
        }
        [dataDic setObject:apiKey forKey:@"API_KEY"];
    }
    
    ConnectionManager *con = [[ConnectionManager alloc] init];
    con.delegate = self;
    [con sendTranData:dataDic];
}

-(void)returnResultWithData:(NSData *)data {
    if (![AppUtils isNull:data]) {
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([[dic objectForKey:@"STATUS"] integerValue] == 1) {
            NSLog(@"success");
        }
    }
}





@end
