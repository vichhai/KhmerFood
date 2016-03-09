//
//  EmailRegisterViewController.m
//  KhmerFood
//
//  Created by kvc on 3/4/16.
//  Copyright © 2016 Donut. All rights reserved.
//

#import "EmailRegisterViewController.h"
#import "NSString+MD5.h"
#import "ShareDataManager.h"

@interface EmailRegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@end

@implementation EmailRegisterViewController

#pragma mark - view lice cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = NaviStandartColor;
    self.navigationController.navigationBar.translucent  = NO;
    [AppUtils settingLeftButton:self action:@selector(leftButtonClicked:) normalImageCode:@"x_button" highlightImageCode:nil];
}

#pragma mark - request and response

-(void)sendRequest:(NSString *)APIKey {
    NSMutableDictionary *requestDic = [[NSMutableDictionary alloc] init];
    NSDictionary *dataDic = nil;
    if ([APIKey isEqualToString:@"KF_CEMAIL"]) { // check available email
        dataDic = @{@"USER_EMAIL" : self.emailTextField.text};
    } else if ([APIKey isEqualToString:@"KF_CUSER"]) { // check available user
        dataDic = @{@"USER_ID" : self.nameTextField.text};
    } else if ([APIKey isEqualToString:@"KF_SIGNUP"]) { // create new user
        dataDic = @{@"USER_ID" : self.nameTextField.text,
                    @"USER_PWD" : [self.passwordTextField.text MD5],
                    @"USER_EMAIL" : self.emailTextField.text,
                    @"ACC_TYPE" : @"L"
                    };
    }
    
    [requestDic setObject:APIKey forKey:@"API_KEY"];
    [requestDic setObject:dataDic forKey:@"REQ_DATA"];
    
    [super sendTranData:requestDic];
}

-(void)returnTransaction:(NSDictionary *)transaction {

    if (![AppUtils isNull:transaction]) {
        
        /*
         * 1 => already existed
         * 2 => not exist
         */
        
        if ([[transaction objectForKey:@"API_KEY"] isEqualToString:@"KF_CEMAIL"]) {
            
            if ([[[transaction objectForKey:@"RESP_DATA"] objectForKey:@"STATUS"] integerValue] == 1) {
                [AppUtils showErrorMessage:@"សូមបញ្ចូលអុីម៉ែលថ្មី\nអីុមែ៉លត្រូវបានប្រើប្រាស់រួចម្ដងហើយ" anyView:self];
                return;
            } else if ([[[transaction objectForKey:@"RESP_DATA"] objectForKey:@"STATUS"] integerValue] == 0) {
                [self sendRequest:@"KF_CUSER"];
            }
            
        } else if([[transaction objectForKey:@"API_KEY"] isEqualToString:@"KF_CUSER"]) {
            
            if ([[[transaction objectForKey:@"RESP_DATA"] objectForKey:@"STATUS"] integerValue] == 1) {
                [AppUtils showErrorMessage:@"សូមបញ្ចូលឈ្មោះថ្មី\nឈ្មោះត្រូវបានប្រើប្រាស់រួចម្ដងហើយ" anyView:self];
                return;
            } else if ([[[transaction objectForKey:@"RESP_DATA"] objectForKey:@"STATUS"] integerValue] == 0) {
                [self sendRequest:@"KF_SIGNUP"];
            }
            
        } else if ([[transaction objectForKey:@"API_KEY"] isEqualToString:@"KF_SIGNUP"]) {
            
            if ([[[transaction objectForKey:@"RESP_DATA"] objectForKey:@"STATUS"] integerValue] == 1){ // success
                [AppUtils showErrorMessage:@"Success" anyView:self];
            } else {
                [AppUtils showErrorMessage:[transaction objectForKey:@"RSLT_MSG"] anyView:self];
                return;
                
            }
        }

    }
    
}


#pragma mark - buttons action
- (IBAction)registerButtonClicked:(UIButton *)sender {
    [self sendRequest:@"KF_CEMAIL"];
}

-(void)leftButtonClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
    [[NSUserDefaults standardUserDefaults] setObject:false forKey:@"isComplateWithEmail"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - textfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{return true;}
- (void)textFieldDidBeginEditing:(UITextField *)textField{}
- (void)textFieldDidEndEditing:(UITextField *)textField{[self.view endEditing:true];}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    long newlength = textField.text.length + string.length - range.length ;
    if (newlength > 8) {return false;}
    return true;
}
@end
