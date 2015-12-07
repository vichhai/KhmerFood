//
//  HomeViewController.m
//  KhmerFood
//
//  Created by kvc on 12/2/15.
//  Copyright © 2015 Donut. All rights reserved.
//

#import "HomeViewController.h"
#import "ConnectionManager.h"
@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestToserver];
}

-(void)requestToserver{

    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]init];
    
    NSDictionary *dic = @{@"USER_ID":@"ee"};
    [dataDic setObject:dic forKey:@"REQ"];
    [dataDic setObject:@"TEST_002" forKey:@"KEY"];
    [super sendTranData:dataDic];
}

-(void)returnTransaction:(NSDictionary *)transaction{
    NSLog(@"Transaction : %@",transaction);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
