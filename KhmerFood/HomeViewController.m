//
//  HomeViewController.m
//  KhmerFood
//
//  Created by kvc on 12/2/15.
//  Copyright © 2015 Donut. All rights reserved.
//

#import "HomeViewController.h"
#import "ConnectionManager.h"
#import "HomeCustomTableViewCell.h"
#import "CustomCollectionViewCell.h"
#import "AppUtils.h"
#import "UIImageView+WebCache.h"
#import "FoodModel.h"
#import "UIView+WebCacheOperation.h"
#import "FoodDetailViewController.h"
#import "AllFoodModel.h"
#define NAVBAR_CHANGE_POINT 0
@interface HomeViewController ()<UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,ConnectionManagerDelegate>

{
    float screenWidth;
    UIScrollView *myScrollView;
    NSMutableArray *headerArray;
    NSMutableArray *rateArray;
    NSMutableArray *randomArray;
    NSMutableArray *aFoodArray;
    
}
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UITableView *homeTableview;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;



@end

@implementation HomeViewController

#pragma mark - view life cycle

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    self.tableView.delegate = nil;
    [self.navigationController.navigationBar lt_reset];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.delegate = self;
    [self scrollViewDidScroll:self.tableView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [AppUtils settingLeftButton:self action:@selector(leftButtonAction:) normalImageCode:@"menu_all_icon" highlightImageCode:nil];
    
    screenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    [self initialScrollView];
    
    if ([[FoodModel allObjects] count] == 0) {
        [self sendTranData:@"KF_LSTMFOOD"];
    } else {
        FoodModel *objFood = [[AppUtils readObjectFromRealm:[[FoodModel alloc] init]] objectAtIndex:0];
        NSDictionary *tempDic = (NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:objFood.foodRecord];
        headerArray = [[NSMutableArray alloc] initWithArray:[tempDic objectForKey:@"HEAD"]];
        aFoodArray = [[NSMutableArray alloc] initWithArray:[tempDic objectForKey:@"AFOOD"]];
        rateArray = [[NSMutableArray alloc] initWithArray:[tempDic objectForKey:@"RATE"]];
        randomArray = [[NSMutableArray alloc] initWithArray:[tempDic objectForKey:@"RANDOM"]];
        if (!headerArray.count == false || headerArray.count != 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setupScrollView];
            });
        }
    }
}

#pragma mark - UICollectionView delegate and datasource methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == 111) {
        return [randomArray count];
    } else if (collectionView.tag == 222) {
        return [rateArray count];
    }
    return [aFoodArray count];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *sendDic;
    if (collectionView.tag == 111) {
        sendDic = [[NSDictionary alloc] initWithDictionary:[randomArray objectAtIndex:indexPath.row]];
    } else if (collectionView.tag == 222) {
        sendDic = [[NSDictionary alloc] initWithDictionary:[rateArray objectAtIndex:indexPath.row]];
    } else {
        sendDic = [[NSDictionary alloc] initWithDictionary:[aFoodArray objectAtIndex:indexPath.row]];
    }
    
    [self performSegueWithIdentifier:@"detail" sender:sendDic];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (collectionView.tag == 111) {
        cell.mylabel.text = [[randomArray objectAtIndex:indexPath.row] objectForKey:@"FD_NAME"];
        cell.foodType.text = [[randomArray objectAtIndex:indexPath.row] objectForKey:@"FD_COOK_TIME"]; //FD_IMG
        [cell.myImage sd_setImageWithURL:[NSURL URLWithString:[[randomArray objectAtIndex:indexPath.row] objectForKey:@"FD_IMG"]]];
    } else if (collectionView.tag == 222) {
        cell.mylabel.text = [[rateArray objectAtIndex:indexPath.row] objectForKey:@"FD_NAME"];
        cell.foodType.text = [[rateArray objectAtIndex:indexPath.row] objectForKey:@"FD_COOK_TIME"]; //FD_IMG
        [cell.myImage sd_setImageWithURL:[NSURL URLWithString:[[rateArray objectAtIndex:indexPath.row] objectForKey:@"FD_IMG"]]];
    } else {
        cell.mylabel.text = [[aFoodArray objectAtIndex:indexPath.row] objectForKey:@"FD_NAME"];
        cell.foodType.text = [[aFoodArray objectAtIndex:indexPath.row] objectForKey:@"FD_COOK_TIME"]; //FD_IMG
        [cell.myImage sd_setImageWithURL:[NSURL URLWithString:[[aFoodArray objectAtIndex:indexPath.row] objectForKey:@"FD_IMG"]]];
    }
    return cell;
}

#pragma mark - segue method
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detail"]) {
        FoodDetailViewController *vc = [segue destinationViewController];
        vc.receiveData = sender;
    }
}


#pragma mark - sroll view did scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView.tag == 9999) {
        UIColor * color = NaviStandartColor;
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY > NAVBAR_CHANGE_POINT) {
            CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
            [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        } else {
            [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        }
    }
    
    if (scrollView.tag == 2000) {
        float pageWidth = myScrollView.bounds.size.width;
        int page = (floorf((myScrollView.contentOffset.x - pageWidth / 2.0) / pageWidth) + 1.0);
        self.pageControl.currentPage = page;
    }
    
}

#pragma mark - notification action
-(void)gotoDetailAction:(NSNotification *)note {

    NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:note.userInfo];

    [self performSegueWithIdentifier:@"detail" sender:dic];
}

#pragma mark - other methods

-(void)scrollingTimer{
    // access the scroll view with the tag
    UIScrollView *scrMain = (UIScrollView*) [self.view viewWithTag:2000];
    
    // same way, access pagecontroll access
    UIPageControl *pgCtr = (UIPageControl*) [self.view viewWithTag:3000];
    
    // get the current offset ( which page is being displayed )
    CGFloat contentOffset = scrMain.contentOffset.x;
    
    // calculate next page to display
    int nextPage = (int)(contentOffset/scrMain.frame.size.width) + 1 ;
    // if page is not 4, display it
    if( nextPage != headerArray.count )  {
        [scrMain scrollRectToVisible:CGRectMake(nextPage*scrMain.frame.size.width, 0, scrMain.frame.size.width, scrMain.frame.size.height) animated:YES];
        pgCtr.currentPage = nextPage;
    } else {        // else start sliding form 1 :)
        [scrMain setContentOffset:CGPointMake(0, 0) animated:YES];
        pgCtr.currentPage = 0;
    }
}

-(void)initialScrollView{
    // initial scroll view
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -64, screenWidth, 194)];
    [self.headerView addSubview:myScrollView];
    myScrollView.delegate = self;
    myScrollView.scrollEnabled = true;
    myScrollView.pagingEnabled = true;
    myScrollView.tag = 2000;
    myScrollView.showsHorizontalScrollIndicator = false;
    
    // gesture recognizer
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDidTap:)];
    tapGesture.numberOfTapsRequired = 1;
    [myScrollView addGestureRecognizer:tapGesture];
}

-(void) setupScrollView {
    
    for (int i = 0; i < headerArray.count; i++) {
        
        NSDictionary *tempDic = [[NSDictionary alloc] initWithDictionary:[headerArray objectAtIndex:i]];
        UIView *tempView = [[UIView alloc] init];
        UIImageView *tempImage = [[UIImageView alloc] init];
        tempImage.tag = 2000 + i;
        
        [tempView addSubview:tempImage];
        tempView.frame = CGRectMake(screenWidth * i, 0, screenWidth,myScrollView.frame.size.height);
        tempImage.frame = CGRectMake(0, 0, tempView.frame.size.width, tempView.frame.size.height);
        [tempImage sd_setImageWithURL:[NSURL URLWithString:[tempDic objectForKey:@"FD_IMG"]]];

        [myScrollView addSubview:tempView];
    }
    myScrollView.backgroundColor = [UIColor whiteColor];
    myScrollView.contentSize = CGSizeMake(screenWidth * headerArray.count, myScrollView.frame.size.height);
    
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = headerArray.count;

    [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(scrollingTimer) userInfo:nil repeats:YES];
}

#pragma mark - button method
- (IBAction)shareButtonMethod:(id)sender {
    [self performSegueWithIdentifier:@"recommend" sender:nil];
}

-(void)leftButtonAction:(UIButton *)sender {
    
}

-(void)tapDidTap:(id)sender {
    NSLog(@"sender is %f",((myScrollView.contentOffset.x + screenWidth) - (myScrollView.contentSize.width / headerArray.count))/screenWidth);
    int index = floorf(((myScrollView.contentOffset.x + screenWidth) - (myScrollView.contentSize.width / headerArray.count))/screenWidth);
    NSDictionary *tempDic = [headerArray objectAtIndex:index];
    [self performSegueWithIdentifier:@"detail" sender:tempDic];
}

#pragma mark - request and response

//request
-(void) sendTranData : (NSString *) apiKey {
    
    ConnectionManager *cont = [[ConnectionManager alloc] init];
    cont.delegate = self;
    NSDictionary *reqDic;
    
    if ([apiKey isEqualToString:@"KF_LSTMFOOD"]) {
        reqDic = @{@"API_KEY":@"KF_LSTMFOOD"};
    } else if ([apiKey isEqualToString:@"KF_LSTFOODS"]) {
        reqDic = @{@"API_KEY":@"KF_LSTFOODS"};
    }
    [cont sendTranData:reqDic];
}

//response
-(void)returnResultWithData:(NSData *)data {
    
    if ([AppUtils isNull:data] == false) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if ([[dic objectForKey:@"API_KEY"] isEqualToString:@"KF_LSTMFOOD"]) { // list main food
          
            if ([[dic objectForKey:@"STATUS"] isEqualToString:@"1"]) {// if success
                
                if ([[FoodModel allObjects] count] == 0 || ![[FoodModel allObjects] count]) {
                    
                    FoodModel *obj = [[FoodModel alloc] init];
                    obj.foodRecord = [NSKeyedArchiver archivedDataWithRootObject:[dic objectForKey:@"RES_DATA"]] ;
                    [AppUtils writeObjectToRealm:obj];
                    headerArray = [[NSMutableArray alloc] initWithArray:[[dic objectForKey:@"RES_DATA"] objectForKey:@"HEAD"]];
                    aFoodArray = [[NSMutableArray alloc] initWithArray:[[dic objectForKey:@"RES_DATA"] objectForKey:@"AFOOD"]];
                    randomArray = [[NSMutableArray alloc] initWithArray:[[dic objectForKey:@"RES_DATA"] objectForKey:@"RANDOM"]];
                    rateArray = [[NSMutableArray alloc] initWithArray:[[dic objectForKey:@"RES_DATA"] objectForKey:@"RATE"]];
                
                    if (!headerArray.count == false || headerArray.count != 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self setupScrollView];
                            [self.collectionRow1 reloadData];
                            [self.collectionRow2 reloadData];
                            [self.collectinRow3 reloadData];
                        });
                    }
                    [self sendTranData:@"KF_LSTFOODS"];
                }
                
            }  // end if success
        } // end list main food
        else if ([[dic objectForKey:@"API_KEY"] isEqualToString:@"KF_LSTFOODS"]) { // get all foods
            if ([[AllFoodModel allObjects] count] == 0) {
                for (NSDictionary *tmpDic in [dic objectForKey:@"RES_DATA"]) {
                    AllFoodModel *allFoodsObj = [[AllFoodModel alloc] init];
                    if ([AppUtils isNull: [tmpDic objectForKey:@"FD_ID"]] == false) {
                        allFoodsObj.foodID = [tmpDic objectForKey:@"FD_ID"];
                    } else {
                        allFoodsObj.foodID = @"";
                    }
                    
                    if ([AppUtils isNull: [tmpDic objectForKey:@"FD_NAME"]] == false) {
                        allFoodsObj.foodName = [tmpDic objectForKey:@"FD_NAME"];
                    } else {
                        allFoodsObj.foodName = @"";
                    }
                    
                    if ([AppUtils isNull: [tmpDic objectForKey:@"FD_DETAIL"]] == false) {
                        allFoodsObj.foodDetail = [tmpDic objectForKey:@"FD_DETAIL"];
                    } else {
                        allFoodsObj.foodDetail = @"";
                    }
                    
                    if ([AppUtils isNull: [tmpDic objectForKey:@"FD_COOK_TIME"]] == false) {
                        allFoodsObj.foodCookTime = [tmpDic objectForKey:@"FD_COOK_TIME"];
                    } else {
                        allFoodsObj.foodCookTime = @"";
                    }
                    
                    if ([AppUtils isNull: [tmpDic objectForKey:@"FD_IMG"]] == false) {
                        allFoodsObj.foodImage = [tmpDic objectForKey:@"FD_IMG"];
                    } else {
                        allFoodsObj.foodImage = @"";
                    }
                    
                    if ([AppUtils isNull: [tmpDic objectForKey:@"FD_RATE"]] == false) {
                        allFoodsObj.foodRate = [tmpDic objectForKey:@"FD_RATE"];
                    } else {
                        allFoodsObj.foodRate = @"";
                    }
                    
                    if ([AppUtils isNull: [tmpDic objectForKey:@"FD_TYPE"]] == false) {
                        allFoodsObj.foodType = [tmpDic objectForKey:@"FD_TYPE"];
                    } else {
                        allFoodsObj.foodType = @"";
                    }
                    
                    if ([AppUtils isNull: [tmpDic objectForKey:@"FD_TIME_WATCH"]] == false) {
                        allFoodsObj.foodTimeWatch = [tmpDic objectForKey:@"FD_TIME_WATCH"];
                    } else {
                        allFoodsObj.foodTimeWatch = @"";
                    }
                    
                    [AppUtils writeObjectToRealm:allFoodsObj];
                }
            }
        }
    }
}

@end
