//
//  ZJCollectionViewPageFlowLayout.m
//  text
//
//  Created by ***鹏辉 on 2019/3/27.
//  Copyright © 2019年 eking.iep. All rights reserved.
//
#import "ZJCollectionViewPageFlowLayout.h"

@interface  ZJCollectionViewPageFlowLayout ()

@property (nonatomic, assign) UIEdgeInsets sectionInsets;
@property (nonatomic, assign) CGFloat miniInterItemSpace;
@property (nonatomic, assign) CGSize eachItemSize;
@property (nonatomic, assign) CGPoint lastOffset;/**<记录上次滑动停止时contentOffset值*/
@property (nonatomic, assign) NSInteger lastIndex;
@property (nonatomic, weak) id delegate;

@end
@implementation  ZJCollectionViewPageFlowLayout

- (instancetype)initWithSectionInset:(UIEdgeInsets)insets andMiniInterItemSpace:(CGFloat)miniInterItemSpace andItemSize:(CGSize)itemSize
{
    self = [self init];
    if (self) {
        //基本尺寸/边距设置
        self.sectionInsets = insets;
        self.miniInterItemSpace = miniInterItemSpace;
        self.eachItemSize = itemSize;
    }
    return self;
}
- (instancetype)init
{
    if (self = [super init])
    {
        
        self.lastOffset = CGPointZero;
    }
    return self;
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (void)prepareLayout
{
    [super prepareLayout];
    // 水平滚动
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.sectionInset = self.sectionInsets;
    self.itemSize = self.eachItemSize;
    self.minimumLineSpacing = self.miniInterItemSpace;
    self.delegate = self.collectionView.delegate;
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat pageSpace = self.eachItemSize.width+self.miniInterItemSpace;//计算分页步距
    CGFloat offsetMax = self.collectionView.contentSize.width - (pageSpace + self.sectionInset.right + self.miniInterItemSpace);
    CGFloat offsetMin = 0;
    if (_lastOffset.x<offsetMin)
    {
        _lastOffset.x = offsetMin;
    }
    else if (_lastOffset.x>offsetMax)
    {
        _lastOffset.x = offsetMax;
    }
    
    CGFloat offsetForCurrentPointX = ABS(proposedContentOffset.x - _lastOffset.x);
    BOOL direction = (proposedContentOffset.x - _lastOffset.x) > 0;
    if (offsetForCurrentPointX > pageSpace/10)
    {
        CGFloat pageOffsetX = pageSpace;
        proposedContentOffset = CGPointMake(_lastOffset.x + (direction?pageOffsetX:-pageOffsetX), proposedContentOffset.y);
    }
    else
    {
        proposedContentOffset = CGPointMake(_lastOffset.x, _lastOffset.y);
    }
    
     NSArray  *arr =   [super layoutAttributesForElementsInRect:CGRectMake(self.collectionView.contentOffset.x, 0, self.collectionView.frame.size.width, self.collectionView.frame.size.height)];
    NSInteger  index = 0;
    if (direction)
    {
        UICollectionViewLayoutAttributes  *Attributes  = arr.lastObject;
        index =  Attributes.indexPath.row;
    }else
    {
        UICollectionViewLayoutAttributes  *Attributes  = arr.firstObject;
        index =  Attributes.indexPath.row;
    }
    if ([self.delegate respondsToSelector:@selector(ZJCollectionViewPageFlowLayout:scrolleToIndex:)])
    {
        [self.delegate ZJCollectionViewPageFlowLayout:self scrolleToIndex:index];
    }
    _lastOffset.x = proposedContentOffset.x;
    return proposedContentOffset;
}

@end
