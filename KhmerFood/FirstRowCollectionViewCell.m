//
//  FirstRowCollectionViewCell.m
//  KhmerFood
//
//  Created by kvc on 12/17/15.
//  Copyright © 2015 Donut. All rights reserved.
//

#import "FirstRowCollectionViewCell.h"
#import "CustomCollectionViewCell.h"
@implementation FirstRowCollectionViewCell

#pragma mark: - collecitonView Delegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.mylabel.text = @"ម្ហូបអាគាំង";
    cell.foodType.text = @"ប្រភេទ អឺរ៉ុប";
    //    for (UIView *view in [cell.contentView subviews]) {
    //        if ([view isEqual:[UIView class]]) {
    //            [view removeFromSuperview];
    //        }
    //    }
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 20;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    let senderDic : NSDictionary = NSDictionary(object: String(sender.tag), forKey: "tagValue");
//    NSNotificationCenter.defaultCenter().postNotificationName("PagePopup2", object: self, userInfo: senderDic as [NSObject : AnyObject])
    
    NSDictionary *senderDic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",indexPath.row],@"tagValue",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goToDetail" object:self userInfo:senderDic];
}

@end
