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
    // Do any additional setup after loading the view.
    arrayData = [[NSArray alloc] initWithObjects:@"សម្លម្ជូរ",@"សាច់គោអាំងទឹកប្រហុក",@"ម្ហូបធ្វើរហ័ស",@"ម្ហូបបួស",@"ម្ហូបចុងសប្ដាហ៏",@"អាហាពេលព្រឹក",@"អាហារសំរ៉ន់",nil];
    self.tagView.canSeletedTags = true;
    self.tagView.tagColor = [UIColor greenColor];
    self.tagView.tagCornerRadius = 5.0f;
    [self.tagView.tags addObjectsFromArray:arrayData];
    
    [self.tagView setCompletionBlockWithSeleted:^(NSInteger index) {
        NSLog(@"______%ld______", (long)index);
        NSLog(@"selected object : %@",[arrayData objectAtIndex:index]);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
