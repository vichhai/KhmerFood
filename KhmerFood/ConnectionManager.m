//
//  ConnectionManager.m
//  KhmerFood
//
//  Created by kvc on 12/1/15.
//  Copyright © 2015 Donut. All rights reserved.
//

#import "ConnectionManager.h"

@interface ConnectionManager()
{
    NSMutableData *responseData;
}
@end

@implementation ConnectionManager 

-(void)sendTranData:(NSDictionary *)reqDictionary{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    // create an URLRequest
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://172.20.20.48/KF_APP_API/API_ME.php"]];
    request.HTTPMethod = @"POST";
//    [request setValue:@"2a1814171e4c995cbc1a7950a67d3db45b4fd139" forHTTPHeaderField:@"X-API-KEY"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:reqDictionary options:0 error:nil];
    
    // checking the format
    NSString *urlString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *stringData = [NSString stringWithFormat:@"%@",urlString];
    [request setHTTPBody:[stringData dataUsingEncoding:NSUTF8StringEncoding]];
    
    // create task
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    
    if (dataTask == nil) {
        responseData = nil;
    } else {
        [dataTask resume];
    }
    
}

#pragma mark - NSURLSession delegate methods

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    [responseData appendData:data];
//    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"str : %@",str);
    [self.delegate returnResultWithData:responseData];
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    responseData = [[NSMutableData alloc] init];
    completionHandler(NSURLSessionResponseAllow);
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    NSLog(@"Oops! error: %@",error.description);
}
@end
