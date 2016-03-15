//
//  ProfileTableViewController.m
//  KhmerFood
//
//  Created by kvc on 12/23/15.
//  Copyright © 2015 Donut. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "AppUtils.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ConnectionManager.h"
#import "AppUtils.h"

@interface ProfileTableViewController () <UIImagePickerControllerDelegate,ConnectionManagerDelegate>
{
    UIImage *profileImageUpload;
}
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *connectionType;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@end

@implementation ProfileTableViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"login_data"] != nil) {
        
        NSDictionary *dicData = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"login_data"]];
        
        _userName.text = [dicData objectForKey:@"user_name"];
        
        if ([[dicData objectForKey:@"login_type"] isEqualToString:@"F"]) {
            _connectionType.text = [NSString stringWithFormat:@"កំពុងភ្ជាប់ជាមួយ %@",@"Facebook"];
        }else {
            _connectionType.text = [NSString stringWithFormat:@"កំពុងភ្ជាប់ជាមួយ %@",@"Twitter"];
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // retrive image on global queue
            
            UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dicData objectForKey:@"profile_pic"]]]]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _profileImage.image = img;
            });
        });
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [AppUtils settingLeftButton:self action:@selector(leftButtonClicked:) normalImageCode:@"x_button" highlightImageCode:nil];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.navigationController.navigationBar.translucent = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark : button aciton
-(void)leftButtonClicked:(UIButton *)sender {
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)logout:(UIButton *)sender {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"login_data"] != nil) {
        NSDictionary *dicData = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"login_data"]];
        if ([[dicData objectForKey:@"login_type"] isEqualToString:@"F"]) {
            [FBSDKAccessToken setCurrentAccessToken:nil];
            [FBSDKProfile setCurrentProfile:nil];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"login_data"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self dismissViewControllerAnimated:true completion:nil];
        } else {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"login_data"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }
}
- (IBAction)chageProfileImage:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate      = self;
    picker.allowsEditing = YES;
    picker.sourceType    = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:nil];
    
}

#pragma mark : Image picker viewcotroller delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    ALAssetsLibraryAssetForURLResultBlock resultBlock = ^(ALAsset *imageAsset){
        
        profileImageUpload = info[UIImagePickerControllerEditedImage];
        NSDictionary *dicData = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"login_data"]];
        
        if ([self uploadImage:UIImageJPEGRepresentation(profileImageUpload, 1.0) filename:[NSString stringWithFormat:@"%@.png",[dicData objectForKey:@"user_name"]] ]) {
//           dispatch_async(dispatch_get_main_queue(), ^{
//               _profileImage.image = profileImageUpload;
//           });
            [self sendTranData];
            
        }
    };
    
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:refURL resultBlock:resultBlock failureBlock:nil];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark : send image to server
- (BOOL)uploadImage:(NSData *)imageData filename:(NSString *)filename   {
    NSString *urlString = @"http://yomankhmerfood.yofoodkh.5gbfree.com/yoman/UploadFileImage.php";
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n",filename]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",returnString);
    
    return ([returnString rangeOfString:@"OK"].location);
}

#pragma request and response 

-(void)sendTranData {
    NSDictionary *dicData = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"login_data"]];
    
    NSDictionary *reqDic = @{@"API_KEY" : @"KF_USERINF",
                             @"USER_ID" : [dicData objectForKey:@"user_id"]};
    
    ConnectionManager *con = [[ConnectionManager alloc] init];
    con.delegate = self;
    [con sendTranData:reqDic];
}

-(void)returnResultWithData:(NSData *)data {
    
    if (![AppUtils isNull:data]) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"data : %@",dic);
//
        if ([[dic objectForKey:@"STATUS"] integerValue] == 1) { // success
            
        }
        
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"login_data"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        NSDictionary *dicData = @{@"user_name":[json valueForKey:@"screen_name"],@"profile_pic":[json valueForKey:@"profile_image_url"],@"login_type":@"T",@"id" : [json objectForKey:@"id"]};
        
        
        
        
        
    }
    
}

@end
