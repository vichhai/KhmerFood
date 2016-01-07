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
#import "CExpandHeader.h"

#define NAVBAR_CHANGE_POINT 0
@interface HomeViewController ()<UITableViewDelegate>

{
//    CExpandHeader *_header;
    float screenWidth;
    UIScrollView *myScrollView;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoDetailAction:) name:@"goToDetail" object:nil];
    
    screenWidth = [[UIScreen mainScreen] bounds].size.width;
    [self setupScrollView];
    
    
}

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

-(void)returnTransaction:(NSDictionary *)transaction{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)leftButtonAction:(UIButton *)sender {

}

#pragma mark - notification action
-(void)gotoDetailAction:(NSNotification *)note {

    NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:note.userInfo];

    [self performSegueWithIdentifier:@"detail" sender:nil];
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
    if( nextPage!=4 )  {
        [scrMain scrollRectToVisible:CGRectMake(nextPage*scrMain.frame.size.width, 0, scrMain.frame.size.width, scrMain.frame.size.height) animated:YES];
        pgCtr.currentPage=nextPage;
        // else start sliding form 1 :)
    } else {
        [scrMain scrollRectToVisible:CGRectMake(0, 0, scrMain.frame.size.width, scrMain.frame.size.height) animated:YES];
        pgCtr.currentPage=0;
    }
}

-(void) setupScrollView {
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -64, screenWidth, 194)];
    [self.headerView addSubview:myScrollView];
    myScrollView.delegate = self;
    myScrollView.scrollEnabled = true;
    myScrollView.pagingEnabled = true;
    myScrollView.tag = 2000;
    myScrollView.showsHorizontalScrollIndicator = false;
    
    NSArray *array = [[NSArray alloc] initWithObjects:@"header.jpg",@"food1.jpg",@"Test",@"food.jpg", nil];
    
    for (int i = 0; i < array.count; i++) {
        UIView *tempView = [[UIView alloc] init];
        UIImageView *tempImage = [[UIImageView alloc] init];
        tempImage.tag = 2000 + i;
        
        // gesture recognizer
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDidTap:)];
        tapGesture.numberOfTapsRequired = 1;
        [myScrollView addGestureRecognizer:tapGesture];
        
        [tempView addSubview:tempImage];
        tempView.frame = CGRectMake(screenWidth * i, 0, screenWidth,myScrollView.frame.size.height);
        tempImage.frame = CGRectMake(0, 0, tempView.frame.size.width, tempView.frame.size.height);
        tempImage.image = [UIImage imageNamed:[array objectAtIndex:i]];
        [myScrollView addSubview:tempView];
    }
    
    myScrollView.contentSize = CGSizeMake(screenWidth * 4.0, myScrollView.frame.size.height);
    
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = array.count;

    [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(scrollingTimer) userInfo:nil repeats:YES];
}

-(void)tapDidTap:(id)sender {
    NSLog(@"sender is %f",((myScrollView.contentOffset.x + screenWidth) - (myScrollView.contentSize.width / 4))/screenWidth);
}

#pragma mark - button method
- (IBAction)shareButtonMethod:(id)sender {
    [self performSegueWithIdentifier:@"recommend" sender:nil];
}


@end
