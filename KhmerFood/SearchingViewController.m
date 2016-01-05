//
//  TestingViewController.m
//  KhmerFood
//
//  Created by kvc on 1/5/16.
//  Copyright © 2016 Donut. All rights reserved.
//

#import "SearchingViewController.h"
#import "JCTagListView.h"

@interface SearchingViewController ()
{
    NSArray *arrayData;
}
@property (weak, nonatomic) IBOutlet JCTagListView *tagView;

@end

@implementation SearchingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    arrayData = [[NSArray alloc] initWithObjects:@"សម្លម្ជូរ",@"សាច់គោអាំងទឹកប្រហុក",@"ម្ហូបធ្វើរហ័ស",@"ម្ហូបបួស",@"ម្ហូបចុងសប្ដាហ៏",@"អាហាពេលព្រឹក",@"អាហារសំរ៉ន់",nil];
    self.navigationController.navigationBar.barTintColor = NaviStandartColor;
    [self setupTagViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - other methods
-(void)setupTagViews{
    self.tagView.canSeletedTags = true;
    self.tagView.tagColor = [UIColor greenColor];
    self.tagView.tagCornerRadius = 14.0f;
    [self.tagView.tags addObjectsFromArray:arrayData];
    
    [self.tagView setCompletionBlockWithSeleted:^(NSInteger index) {
        NSLog(@"______%ld______", (long)index);
        NSLog(@"selected object : %@",[arrayData objectAtIndex:index]);
        [self performSegueWithIdentifier:@"recommend" sender:nil];
    }];
}

#pragma mark - buttons action
-(void)lettButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
}
@end
