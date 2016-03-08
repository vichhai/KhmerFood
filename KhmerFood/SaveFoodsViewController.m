//
//  SaveFoodsViewController.m
//  KhmerFood
//
//  Created by Yoman on 12/17/15.
//  Copyright © 2015 Donut. All rights reserved.
//

#import "SaveFoodsViewController.h"
#import "CardViewMe.h"
#import "YSLDraggableCardContainer.h"
#import "FoodDetailViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define RGB(r, g, b)	 [UIColor colorWithRed: (r) / 255.0 green: (g) / 255.0 blue: (b) / 255.0 alpha : 1]

@interface SaveFoodsViewController () <YSLDraggableCardContainerDelegate, YSLDraggableCardContainerDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    SaveFoodModel *realmSaveFood;
    UIImage *StrImageData;
    NSString *StrImageName;
    
}


@property (nonatomic, strong) YSLDraggableCardContainer *container;
@property (nonatomic, strong) NSMutableArray *datas;
@property (strong, nonatomic) IBOutlet UIView *viewMessage;

@end

@implementation SaveFoodsViewController
//=====YOMAM======//
- (IBAction)btnSaveAction:(UIButton *)sender {
    [self uploadImage:UIImageJPEGRepresentation(StrImageData, 1.0) filename:StrImageName];
}
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
    return ([returnString isEqualToString:@"OK"]);
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset){
        ALAssetRepresentation *imageRep = [imageAsset defaultRepresentation];

        StrImageName =[imageRep filename];
        StrImageData =info[UIImagePickerControllerEditedImage]; // image
    };
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:refURL resultBlock:resultblock failureBlock:nil];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad                     {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(235, 235, 235);
    
    _container = [[YSLDraggableCardContainer alloc]init];
    _container.frame = CGRectMake(25 , self.view.frame.size.height / 6 , self.view.frame.size.width - 50, self.view.frame.size.height / 2);
    _container.dataSource = self;
    _container.delegate   = self;
    _container.canDraggableDirection = YSLDraggableDirectionLeft | YSLDraggableDirectionRight ;
    [self.view addSubview:_container];
    
  
    //=====YOMAM======//
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.delegate      = self;
//    picker.allowsEditing = YES;
//    picker.sourceType    = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//    [self presentViewController:picker animated:YES completion:nil];
    
    
}
- (void)viewWillAppear:(BOOL)animated   {
    [super viewWillAppear:animated];
    
    _datas = [NSMutableArray array];
    
    [self performSegueWithIdentifier:@"ShareFIrSegue" sender:nil];
    
    
    realmSaveFood = [[SaveFoodModel alloc]init];
    for (int i = 0 ; i < [AppUtils readObjectFromRealm:realmSaveFood].count ; i++){
        [_datas addObject:[AppUtils readObjectFromRealm:realmSaveFood][i]];
    }
    
    if([ShareDataManager shareDataManager].SCheckRealoadSaveFood == true){
        [_container reloadCardContainer];
        [ShareDataManager shareDataManager].SCheckRealoadSaveFood = false;
    }
}

#pragma mark -- YSLDraggableCardContainer DataSource
- (UIView *)cardContainerViewNextViewWithIndex:(NSInteger)index     {
    NSDictionary *dict = _datas[index];
    CardViewMe *view;
    view = [[CardViewMe alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 50, self.view.frame.size.height / 2)];
    view.backgroundColor = [UIColor whiteColor];
    [view.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dict[@"FD_IMG"]]]];
    view.label.text = [NSString stringWithFormat:@"%@",dict[@"FD_NAME"]];
    view.labelName.text = [NSString stringWithFormat:@"%@",dict[@"FD_COOK_TIME"]];
    return view;
}
- (NSInteger)cardContainerViewNumberOfViewInIndex:(NSInteger)index  {
    if(_datas.count == 0){
        _viewMessage.hidden = false;
    }else{
        _viewMessage.hidden = true;
    }
    return _datas.count;
}

#pragma mark -- YSLDraggableCardContainer Delegate
- (void)cardContainerView:(YSLDraggableCardContainer *)cardContainerView didEndDraggingAtIndex:(NSInteger)index draggableView:(UIView *)draggableView draggableDirection:(YSLDraggableDirection)draggableDirection{
    
    if (draggableDirection == YSLDraggableDirectionLeft) {
        [cardContainerView movePositionWithDirection:draggableDirection isAutomatic:NO];
    }
    if (draggableDirection == YSLDraggableDirectionRight) {
        [cardContainerView movePositionWithDirection:draggableDirection isAutomatic:NO undoHandler:^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ពត៏មាន"
                                                                                     message:@"តេីអ្នកចង់លុបអាហារចេញពីកន្លែងរក្សាទុករបស់អ្នកមែន៎ទេ ?"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"បាន" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [cardContainerView movePositionWithDirection:draggableDirection isAutomatic:NO];
                [AppUtils DeleteObjectToRealm:[AppUtils readObjectFromRealm:realmSaveFood][index]];
                [_datas removeObjectAtIndex:index];
                [_container reloadCardContainer];
            }]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"អត់ទេ បាន" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [cardContainerView movePositionWithDirection:YSLDraggableDirectionDefault isAutomatic:YES];
            }]];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }];
    }

}
- (void)cardContainderView:(YSLDraggableCardContainer *)cardContainderView updatePositionWithDraggableView:(UIView *)draggableView draggableDirection:(YSLDraggableDirection)draggableDirection widthRatio:(CGFloat)widthRatio heightRatio:(CGFloat)heightRatio{
    CardViewMe *view = (CardViewMe *)draggableView;
    
    if (draggableDirection == YSLDraggableDirectionDefault) {
        view.selectedView.alpha = 0;
    }
    
    if (draggableDirection == YSLDraggableDirectionLeft) {
        view.selectedView.backgroundColor = RGB(215, 104, 91);
        view.selectedView.alpha = widthRatio > 0.8 ? 0.8 : widthRatio;
    }
    
    if (draggableDirection == YSLDraggableDirectionRight) {
        view.selectedView.backgroundColor = RGB(114, 209, 142);
        view.selectedView.alpha = widthRatio > 0.8 ? 0.8 : widthRatio;
    }
    
}
- (void)cardContainerViewDidCompleteAll:(YSLDraggableCardContainer *)container;{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{\
        [container reloadCardContainer];
    });
}
- (void)cardContainerView:(YSLDraggableCardContainer *)cardContainerView didSelectAtIndex:(NSInteger)index draggableView:(UIView *)draggableView{
    
    NSDictionary *receiveData = [[NSDictionary alloc]initWithObjectsAndKeys:_datas[index][@"FD_ID"],@"FD_ID",_datas[index][@"FD_NAME"],@"FD_NAME",_datas[index][@"FD_DETAIL"],@"FD_DETAIL",_datas[index][@"FD_COOK_TIME"],@"FD_COOK_TIME",_datas[index][@"FD_IMG"],@"FD_IMG",_datas[index][@"FD_RATE"],@"FD_RATE",_datas[index][@"FD_TYPE"],@"FD_TYPE",_datas[index][@"FD_TIME_WATCH"],@"FD_TIME_WATCH",nil];
    
//    [self performSegueWithIdentifier:@"SaveFDDFSegue" sender:receiveData];
   
}

#pragma mark - segue method
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"SaveFDDFSegue"]) {
//        FoodDetailViewController *vc = [segue destinationViewController];
//        vc.receiveData = sender;
//    }
}


@end
