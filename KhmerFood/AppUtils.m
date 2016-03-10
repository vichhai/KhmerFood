//
//  AppUtils.m
//  Senate News
//
//  Created by vichhai on 9/4/15.
//  Copyright (c) 2015 GITS. All rights reserved.
//

#import "AppUtils.h"



@interface AppUtils ()

@end

@implementation AppUtils

/////////////////////////////////////////////////////////////////////////////////////////////

+(void)setLineHeight:(NSString *)string anyLabel:(UILabel *)anylabel {
    
    NSString *labelText = string;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];
    paragraphStyle.alignment = NSTextAlignmentJustified;
    paragraphStyle.firstLineHeadIndent = 0;

    NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraphStyle};
    //    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    [attributedString addAttributes:attributes range:NSMakeRange(0, [labelText length])];
    anylabel.attributedText = attributedString ;
    
}

/////////////////////////////////////////////////////////////////////////////////////////////
+(void)hideLoading:(UIView *)anyView{
    
//    [MBProgressHUD hideAllHUDsForView:anyView animated:true];
}

/////////////////////////////////////////////////////////////////////////////////////////////
+(void)showLoading:(UIView *)anyView{
    // =---> show loading
//    MBProgressHUD *loading = [MBProgressHUD showHUDAddedTo:anyView animated:true];
//    loading.mode = MBProgressHUDModeIndeterminate;
//    loading.labelText = @"Loading";
}

/////////////////////////////////////////////////////////////////////////////////////////////
+(CGFloat)getDeviceScreenHeight{
    return [[UIScreen mainScreen] bounds].size.height;
}

/////////////////////////////////////////////////////////////////////////////////////////////
+(CGFloat)getDeviceScreenWidth {
    return [[UIScreen mainScreen] bounds].size.width;
}

/////////////////////////////////////////////////////////////////////////////////////////////
+(void)showErrorMessage:(NSString *)message anyView:(id)object{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ការណែនាំ" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//    [alert show];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"ព័ត៌មាន" message:message preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"យល់ព្រម" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okButton];
    [object presentViewController:alert animated:true completion:nil];
}

/////////////////////////////////////////////////////////////////////////////////////////////
+ (void)settingNavigationBarTitle:(id)aTarget title:(NSString *)title {
    
    if ([aTarget isKindOfClass:[UIViewController class]] == NO)
        return;
    
    UIViewController *viewController = aTarget;
    viewController.navigationItem.title = title;
}

/////////////////////////////////////////////////////////////////////////////////////////////
+ (void)settingLeftButton:(id)aTarget action:(SEL)aAction normalImageCode:(NSString *)aNormalImageCode highlightImageCode:(NSString *)aHighlightImageCode{
    
    if ([aTarget isKindOfClass:[UIViewController class]] == NO)
        return;
    
    UIViewController* calleeViewCtrl	= aTarget;
    UIImage* imgNormal					= [UIImage imageNamed:aNormalImageCode];
    
    UIButton* btnNewLeft				= [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, imgNormal.size.width/2, imgNormal.size.height/2)];
    
    [btnNewLeft setTag:10000];
    [btnNewLeft setBackgroundImage:imgNormal forState:UIControlStateNormal];
    
    if ([AppUtils isNull:aHighlightImageCode] == NO)
        [btnNewLeft setBackgroundImage:[UIImage imageNamed:aHighlightImageCode] forState:UIControlStateHighlighted];
    
    [btnNewLeft addTarget:calleeViewCtrl action:aAction forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* btnNewBarLeft					= [[UIBarButtonItem alloc] initWithCustomView:btnNewLeft];
    calleeViewCtrl.navigationItem.leftBarButtonItem	= btnNewBarLeft;
}

/////////////////////////////////////////////////////////////////////////////////////////////
+ (void)settingRightButton:(id)aTarget action:(SEL)aAction normalImageCode:(NSString *)aNormalImageCode highlightImageCode:(NSString *)aHighlightImageCode {
    if ([aTarget isKindOfClass:[UIViewController class]] == NO)
        return;
    
    if ([AppUtils isNull:aNormalImageCode] == YES)
        return;
    
    UIViewController* calleeViewCtrl	= aTarget;
    UIImage* imgNormal					= [UIImage imageNamed:aNormalImageCode];
    UIButton* btnNewRight				= [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, imgNormal.size.width/2, imgNormal.size.height/2)];
    
    [btnNewRight setTag:10001];
    [btnNewRight setBackgroundImage:imgNormal forState:UIControlStateNormal];
    
    if ([AppUtils isNull:aHighlightImageCode] == NO)
        [btnNewRight setBackgroundImage:[UIImage imageNamed:aHighlightImageCode] forState:UIControlStateHighlighted];
    
    [btnNewRight addTarget:calleeViewCtrl action:aAction forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* btnNewBarRight						= [[UIBarButtonItem alloc] initWithCustomView:btnNewRight];
    calleeViewCtrl.navigationItem.rightBarButtonItem	= btnNewBarRight;
}

/////////////////////////////////////////////////////////////////////////////////////////////
+ (BOOL)isNull:(id) obj{
    if (obj == nil || obj == [NSNull null])
        return YES;
    
    if ([obj isKindOfClass:[NSString class]] == YES) {
        if ([(NSString *)obj isEqualToString:@""] == YES)
            return YES;
        
        if ([(NSString *)obj isEqualToString:@"<null>"] == YES)
            return YES;
        
        if ([(NSString *)obj isEqualToString:@"null"] == YES)
            return YES;
    }
    
    return NO;
}

/////////////////////////////////////////////////////////////////////////////////////////////
+ (NSInteger)getOSVersion {
    return [[[UIDevice currentDevice] systemVersion] integerValue];
}

/////////////////////////////////////////////////////////////////////////////////////////////
+(void)writeObjectToRealm:(RLMObject *)anyObject {
    [UIRealm beginWriteTransaction];
    [UIRealm addObject:anyObject];
    [UIRealm commitWriteTransaction];
}
/////////////////////////////////////////////////////////////////////////////////////////////
+(void)DeleteObjectToRealm:(RLMObject *)anyObject {
    [UIRealm beginWriteTransaction];
    [UIRealm deleteObject:anyObject];
    [UIRealm commitWriteTransaction];
}
/////////////////////////////////////////////////////////////////////////////////////////////
+(RLMResults *)readObjectFromRealm:(RLMObject *)anyObject{
    return [[anyObject class] allObjects];
}

+ (CGFloat)measureTextHeight:(NSString*)text constrainedToSize:(CGSize)constrainedToSize fontSize:(CGFloat)fontSize {
    
    CGRect rect = [text boundingRectWithSize:constrainedToSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    
    return rect.size.height;
    
}
/////////////////////////////////////////////////////////////////////////////////////////////
+(void)showWaitingActivity:(UIView *)anyView{
    
    parentView = anyView;
    
    
    if (anyView.tag == 9999999) {
        wrapperView = [[UIView alloc] initWithFrame:CGRectMake(0, -65, anyView.frame.size.width, anyView.frame.size.height + 90)];
    } else {
        wrapperView = [[UIView alloc] initWithFrame:anyView.frame];
    }
    wrapperView.backgroundColor = [UIColor darkGrayColor];
    wrapperView.alpha = 0.7;
    
    UIView *innerWrapperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 130)];
    innerWrapperView.center = wrapperView.center;
    innerWrapperView.backgroundColor = [UIColor clearColor];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 99, 100, 31)];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = @"កំពុងដំណើរការ";
    
    loadingImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    loadingImage.backgroundColor = [UIColor clearColor];
    loadingImage.layer.cornerRadius = 50;
    
    NSMutableArray *arrOfImages = [[NSMutableArray alloc] init];
    
//    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i = 1; i <= 161; i++) {
            NSString *imageName = [NSString stringWithFormat:@"loading-%d (dragged).tiff",i];
            [arrOfImages addObject:[UIImage imageNamed:imageName]];
        }
        
        loadingImage.animationImages = arrOfImages;
        
        // set duration
        loadingImage.animationDuration = 4.5;
        [loadingImage startAnimating];
//    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        anyView.userInteractionEnabled = false;
        [innerWrapperView addSubview:loadingImage];
        [innerWrapperView addSubview:textLabel];
        [wrapperView addSubview:innerWrapperView];
        [anyView addSubview:wrapperView];
    });
}

+(void)hideWaitingActivity {
    if (parentView != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [loadingImage stopAnimating];
            [wrapperView removeFromSuperview];
            parentView = nil;
        });
        parentView.userInteractionEnabled = true;
    }
}
@end
