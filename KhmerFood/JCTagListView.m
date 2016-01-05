//
//  JCTagListView.m
//  JCTagListView
//
//  Created by 李京城 on 15/7/3.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import "JCTagListView.h"
#import "JCTagCell.h"
#import "JCCollectionViewTagFlowLayout.h"

@interface JCTagListView ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSArray *arrayColor;
}
@property (nonatomic, copy) JCTagListViewBlock seletedBlock;

@end

@implementation JCTagListView

static NSString * const reuseIdentifier = @"tagListViewItemId";

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
}

- (void)setup
{
    _seletedTags = [NSMutableArray array];
    
    self.tags = [NSMutableArray array];
    
    self.tagColor = [UIColor darkGrayColor];
    self.tagCornerRadius = 10.0f;
    
    JCCollectionViewTagFlowLayout *layout = [[JCCollectionViewTagFlowLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[JCTagCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self addSubview:self.collectionView];
    
    arrayColor = [[NSArray alloc] initWithObjects:[UIColor redColor],[UIColor greenColor],[UIColor yellowColor],[UIColor greenColor], nil];
}

- (void)setCompletionBlockWithSeleted:(JCTagListViewBlock)completionBlock
{
    self.seletedBlock = completionBlock;
}

#pragma mark - UICollectionViewDelegate | UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tags.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JCCollectionViewTagFlowLayout *layout = (JCCollectionViewTagFlowLayout *)collectionView.collectionViewLayout;
    CGSize maxSize = CGSizeMake(collectionView.frame.size.width - layout.sectionInset.left - layout.sectionInset.right, layout.itemSize.height);
    
    CGRect frame = [self.tags[indexPath.item] boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]} context:nil];
    
    return CGSizeMake(frame.size.width + 20.0f, layout.itemSize.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int r = arc4random_uniform(4);
    JCTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor whiteColor];
//    cell.titleLabel.textColor = self.tagColor;
    cell.layer.borderColor = [[arrayColor objectAtIndex:r] CGColor];
    cell.layer.cornerRadius = self.tagCornerRadius;
    cell.backgroundColor = [arrayColor objectAtIndex:r];
    cell.titleLabel.text = self.tags[indexPath.item];
    cell.titleLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    if (self.canSeletedTags) {
//        JCTagCell *cell = (JCTagCell *)[collectionView cellForItemAtIndexPath:indexPath];
//        cell.backgroundColor = self.tagColor;
//        if ([_seletedTags containsObject:self.tags[indexPath.item]]) { // deselect
////            cell.backgroundColor = [UIColor whiteColor];
//            
//            cell.backgroundColor = self.tagColor;
//            
////            [_seletedTags removeObject:self.tags[indexPath.item]];
//            [_seletedTags removeAllObjects];
//        }
//        else { // select
//            cell.backgroundColor = [UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1];
//            [_seletedTags removeAllObjects];
//            [_seletedTags addObject:self.tags[indexPath.item]];
//        }
        
        
    }
    
    if (self.seletedBlock) {
        self.seletedBlock(indexPath.item);
    }
}

@end
