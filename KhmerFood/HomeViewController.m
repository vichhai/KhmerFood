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
    int nextPage;
}
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
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
    UIColor * color = [UIColor colorWithRed:43/255.0 green:180/255.0 blue:142/255.0 alpha:1];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
    
    if (scrollView.tag == 2000) {
        float pageWidth = self.myScrollView.bounds.size.width;
        int page = (floorf((self.myScrollView.contentOffset.x - pageWidth / 2.0) / pageWidth) + 1.0);
        self.pageControl.currentPage = page;
    }
    
}

-(void)returnTransaction:(NSDictionary *)transaction{
    NSLog(@"Transaction : %@",transaction);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)leftButtonAction:(UIButton *)sender {
    NSLog(@"Kikilu");
}

#pragma mark: - notification action
-(void)gotoDetailAction:(NSNotification *)note {

    NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:note.userInfo];
    NSLog(@"other class: %@",dic);
    [self performSegueWithIdentifier:@"detail" sender:nil];
}

#pragma mark : other methods

-(void)scrollingTimer{
    // access the scroll view with the tag
    UIScrollView *scrMain = (UIScrollView*) [self.view viewWithTag:2000];
    NSLog(@"scMain : %f",scrMain.contentSize);
    
    // same way, access pagecontroll access
    UIPageControl *pgCtr = (UIPageControl*) [self.view viewWithTag:3000];
    // get the current offset ( which page is being displayed )
    CGFloat contentOffset = scrMain.contentOffset.y;
    // calculate next page to display
    nextPage = (int)(contentOffset/scrMain.frame.size.height) + 1 ;
    // if page is not 10, display it
    if( nextPage!=4 )  {
        
        [scrMain scrollRectToVisible:CGRectMake(0, nextPage*scrMain.frame.size.height, scrMain.frame.size.width, scrMain.frame.size.height) animated:YES];
        pgCtr.currentPage=nextPage;
        // else start sliding form 1 :)
        
    } else {
        
        [scrMain scrollRectToVisible:CGRectMake(0, 0, scrMain.frame.size.width, scrMain.frame.size.height) animated:YES];
        pgCtr.currentPage=0;
    }
}

-(void) setupScrollView {
    self.myScrollView.scrollEnabled = true;
    self.myScrollView.pagingEnabled = true;
    
    NSArray *array = [[NSArray alloc] initWithObjects:@"header.jpg",@"food1.jpg",@"Test",@"food.jpg", nil];
    
    for (int i = 0; i < array.count; i++) {
        UIView *tempView = [[UIView alloc] init];
        UIImageView *tempImage = [[UIImageView alloc] init];
        [tempView addSubview:tempImage];
        tempView.frame = CGRectMake(screenWidth * i, 0, screenWidth,/*self.myScrollView.frame.size.height*/194);
        tempImage.frame = CGRectMake(0, 0, tempView.frame.size.width, tempView.frame.size.height);
        tempImage.image = [UIImage imageNamed:[array objectAtIndex:i]];
        [self.myScrollView addSubview:tempView];
    }
    self.myScrollView.contentSize = CGSizeMake(self.view.frame.size.width * 4.0, self.myScrollView.frame.size.height);
    self.myScrollView.autoresizingMask=UIViewAutoresizingNone;
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = array.count;

    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scrollingTimer) userInfo:nil repeats:YES];
}

@end
