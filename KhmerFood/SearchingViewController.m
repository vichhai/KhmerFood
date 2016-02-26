//
//  TestingViewController.m
//  KhmerFood
//
//  Created by kvc on 1/5/16.
//  Copyright © 2016 Donut. All rights reserved.
//

#import "SearchingViewController.h"
#import "JCTagListView.h"
#import "AllFoodModel.h"
#import "SearchCustomCellTableViewCell.h"
#import "FoodDetailViewController.h"
#import <Realm/Realm.h>

@interface SearchingViewController () <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

{
    NSArray *arrayData;
    RLMResults<AllFoodModel *> *allFoodsArray;
    NSMutableArray *searchResultArray;
    BOOL isSearching;
}

@property (weak, nonatomic) IBOutlet JCTagListView *tagView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation SearchingViewController

#pragma mark - view life cycle

-(void)viewWillAppear:(BOOL)animated {
//    [searchResultArray removeAllObjects];
//    [self.myTableView reloadData];
    self.navigationController.navigationBar.barTintColor = NaviStandartColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self readDataFromRealm];
    
    NSMutableSet *set = [[NSMutableSet alloc] init];
    
    for (AllFoodModel *obj in allFoodsArray) { // get type of food
        NSString *foodType = @"";
        
        if ([obj.foodType isEqualToString:@"D1"]) {
            foodType = @"ឆា";
        }else if ([obj.foodType isEqualToString:@"D2"]) {
            foodType = @"ស្ងោ";
        }else if ([obj.foodType isEqualToString:@"D3"]) {
            foodType = @"ចៀន";
        }else if ([obj.foodType isEqualToString:@"D4"]) {
            foodType = @"ញាំ";
        }else if ([obj.foodType isEqualToString:@"D5"]) {
            foodType = @"ចំហុយ";
        }else if ([obj.foodType isEqualToString:@"D6"]) {
            foodType = @"បំពង";
        }else if ([obj.foodType isEqualToString:@"D7"]) {
            foodType = @"ភ្លៀរ";
        }else if ([obj.foodType isEqualToString:@"D8"]) {
            foodType = @"អាំង";
        }
        
        [set addObject:foodType];
    }
    arrayData = [[NSArray alloc] initWithArray:[set allObjects]];
    
    [self setupTagViews];
    self.myTableView.hidden = true;
    
}

#pragma mark - uitableview data source and delegate method

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchCustomCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (isSearching) {
        [cell.foodName setAttributedText:[searchResultArray objectAtIndex:indexPath.row]];
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isSearching) {
        return [searchResultArray count];
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *foodTitle = [[searchResultArray objectAtIndex:indexPath.row] string];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"foodName = %@",foodTitle];
    AllFoodModel *obj = [[ AllFoodModel objectsWithPredicate:pred] objectAtIndex:0];
    NSDictionary *tempDic = @{@"FD_ID":obj.foodID,
                              @"FD_NAME":obj.foodName,
                              @"FD_DETAIL":obj.foodDetail,
                              @"FD_COOK_TIME":obj.foodCookTime,
                              @"FD_IMG":obj.foodImage,
                              @"FD_RATE":obj.foodRate,
                              @"FD_TYPE":obj.foodType,
                              @"FD_TIME_WATCH":obj.foodTimeWatch
                              };
//    NSDictionary *tempDic;
//    for (NSDictionary *dic in allFoodsArray) {
//        if ([[dic objectForKey:@"FD_NAME"] isEqualToString:foodTitle]) {
//            tempDic = dic;
//            break;
//        }
//    }
    [self performSegueWithIdentifier:@"detail" sender:tempDic];
}

#pragma mark - read data from Realm
-(void)readDataFromRealm {
//    AllFoodModel *objFood = [[AppUtils readObjectFromRealm:[[AllFoodModel alloc] init]] objectAtIndex:0];
//    allFoodsArray = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:objFood.allFoods];
    allFoodsArray = [AppUtils readObjectFromRealm:[[AllFoodModel alloc] init]];
}

#pragma mark - other methods
-(void)setupTagViews{
    self.tagView.canSeletedTags = true;
    self.tagView.tagColor = [UIColor greenColor];
    self.tagView.tagCornerRadius = 14.0f;
    [self.tagView.tags addObjectsFromArray:arrayData];
    
    [self.tagView setCompletionBlockWithSeleted:^(NSInteger index) {
        [self performSegueWithIdentifier:@"recommend" sender:nil];
    }];
}

#pragma mark - buttons action

- (IBAction)closeButtonAction:(UIButton *)sender {
    isSearching = false;
    self.myTableView.hidden = true;
    [self.myTableView reloadData];
    self.searchTextField.text = nil;
    [self.searchTextField resignFirstResponder];
}

#pragma mark - textfield delegate 

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    isSearching = true;
    
    [searchResultArray removeAllObjects];
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@",newString];
    NSMutableArray *titleArray = [[NSMutableArray alloc] init];
    
    for (AllFoodModel *obj in allFoodsArray) {
        [titleArray addObject:obj.foodName];
    }
    
    NSArray *tempArray = [titleArray filteredArrayUsingPredicate:searchPredicate];
    
    NSMutableArray *stringColorArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [tempArray count]; i++) {
        NSString *baseString = [tempArray objectAtIndex:i];
        NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:baseString];
        NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:newString options:NSRegularExpressionCaseInsensitive error:nil];
        
        NSRange range = NSMakeRange(0, [baseString length]);
        [regex enumerateMatchesInString:baseString options:0 range:range usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        
            [attributed addAttribute:NSBackgroundColorAttributeName value:[UIColor brownColor] range:[result rangeAtIndex:0]];
            [stringColorArray addObject:attributed];
            
        }];
    }
    
    if ([stringColorArray count] != 0 ) {
        searchResultArray = stringColorArray;
    }
    [self.myTableView reloadData];
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    self.myTableView.hidden = false;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField {
    return true;
}

#pragma mark - segue method

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detail"]) {
        FoodDetailViewController *vc = [segue destinationViewController];
        vc.receiveData = sender;
        [self.searchTextField resignFirstResponder];
    }
}

@end
