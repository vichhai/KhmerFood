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

#define NAVBAR_CHANGE_POINT 0
@interface FoodDetailViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UILabel *titleLable;
}
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
    
    titleLable =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
    [titleLable setFont:[UIFont systemFontOfSize:17]];
    titleLable.textColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self scrollViewDidScroll:self.tableView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.navigationController.navigationBar.translucent = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    cell.myLabel.text = @"គ្រឿងផ្សំ បង្កង ត្រី​រ៉ស់ សាច់ជ្រូក (​សាច់​សុទ្ធ​) ថ្លើម​ជ្រូក ពោះវៀន​ខ្ចី ខ្ញី អំបិល ទឹកស៊ីអ៊ីវ​ស ម្សៅ​ស៊ុប ម្សៅ​មី ដើម​ខ្ទឹម ស្លឹក​វ៉ានស៊ុយ ម្រេច​បុក ខ្ទឹមស ខ្លាញ់​រាវ ។ \nវិធី​ធ្វើ\n១. ត្រី​រ៉ស់ លើ​យ​យកតែ​សាច់​ហាន់​ជា​បន្ទះ​ស្ដើងៗ ថ្លើម​ជ្រូក​ហាន់​ជា​បន្ទះ​ស្ដើង​ដែរ ខ្ញី​រើសយក ខ្ចី ចិត​សំបក​ហាន់​ជា​សរសៃ​ឆ្មារៗ គល់​ខ្ទឹម​កាត់​ប្រវែង​ពីរ​ថ្នាំងដៃ សាប់​ចុង​ដើម​ត្រាំ​ទឹក​ឲ្យ​រីក ស្លឹក​វ៉ាន់ស៊ុយបេះ​លាង​ទឹក​ឲ្យ​ស្អាត ។\n២. សាច់ជ្រូក (​សាច់​សុទ្ធ​) ចិញ្ច្រាំ​ឲ្យ​ល្អិត​ដាក់​ម្សៅ​មី​បន្តិច​សូន​មូលៗ ប៉ុន​មេដៃ ពោះវៀន​ខ្ចី​កាត់កង់ៗ​ប្រវែង​មួយ​ថ្នាំងដៃ ខ្ទឹមស​ចិញ្ច្រាំ​ឲ្យ​ល្អិត​បំពង​ខ្លាញ់​ឲ្យ​ឈ្ងុយ ដាក់​ចាន​ទុក ។\n៣. យក​អង្ករ​ដាំបបរ (​រាវៗ​) ហើយ​ដាក់​ពោះវៀន​ខ្ចី អំបិល ម្សៅ​ស៊ុប​ទុក​ឲ្យ​ឆ្អិន ទើប​ដាក់​សាច់ជ្រូក​ចិញ្ច្រាំ ។\nរបៀប​រៀប​ទទួលទាន\n៤. យក​ចាន​ដាក់​ថ្លើម​ជ្រូក សាច់​ត្រី ខ្ញី គល់​ខ្ទឹម រួច​ដួស​បបរ (​កំពុងពុះ​) ដាក់​ពីលើ​រោយ​ខ្ទឹមបំពង ចាក់​ទឹកស៊ីអ៊ីវ​ស និង​ម្រេច​បុក ស្លឹក​វ៉ាន់ស៊ុយ ។​";
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark - scrollview delegate method

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIColor * color = [UIColor colorWithRed:43/255.0 green:180/255.0 blue:142/255.0 alpha:1];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        titleLable.text = @"បបរសាមចូក";
        self.navigationItem.titleView = titleLable;
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        titleLable.text = nil;
        self.navigationItem.titleView = titleLable;
    }
}

#pragma mark - buttons methods

-(void)btnSaveClicked:(UIButton *)sender {
    NSLog(@"save button work");
}

-(void)btnShareClicked:(UIButton *)sender {
    NSLog(@"share button work");
}

-(void)lettButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
}

@end
