//
//  TestViewController.m
//  KhmerFood
//
//  Created by Yoman on 12/23/15.
//  Copyright © 2015 Donut. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UIImageView *imageMe;
@property (strong, nonatomic) IBOutlet UIWebView *webViewME;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   [self requestToserver];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)requestToserver{
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]init];
    
    NSDictionary *dic = @{@"USER_ID":@"ee"};
    [dataDic setObject:dic forKey:@"REQ"];
    [dataDic setObject:@"TEST_002" forKey:@"KEY"];
    [super sendTranData:dataDic];
}
-(void)returnTransaction:(NSDictionary *)transaction{
    //    NSLog(@"Transaction : %@",transaction);
    
    _lblName.text = transaction[@"RES_DATA"][@"RECORDS"][0][@"FD_NAME"];
    
    _imageMe.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://172.20.20.48/~yoman/KF_APP_API/image/%@",transaction[@"RES_DATA"][@"RECORDS"][0][@"FD_IMG"]]]]];
    
    [_webViewME loadHTMLString: transaction[@"RES_DATA"][@"RECORDS"][0][@"FD_DETAIL"] baseURL: nil];
    
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
