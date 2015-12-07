//
//  KFViewController.m
//  KhmerFood
//
//  Created by kvc on 12/1/15.
//  Copyright © 2015 Donut. All rights reserved.
//

#import "KFViewController.h"

@interface KFViewController ()

@end

@implementation KFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void)returnResult:(NSDictionary *)result {
    
}

-(void)returnResultWithData:(NSData *)data{
//    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    [self returnTransaction:dic];
//    [AppUtils showErrorMessage:@"error" anyView:self];
//    [self returnTransaction:str];
}

-(void)sendTranData:(NSDictionary *)requestDic{
    ConnectionManager *cont = [[ConnectionManager alloc] init];
    cont.delegate = self;
    [cont sendTranData:requestDic];
}

-(void)returnTransaction:(NSDictionary *)transaction{
    
}
@end
