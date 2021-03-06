//
//  ZJCollectionViewPageFlowLayout.h
//  text
//
//  Created by ***鹏辉 on 2019/3/27.
//  Copyright © 2019年 eking.iep. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJCollectionViewPageFlowLayout;
@protocol ZJCollectionViewPageFlowLayoutProtocol <NSObject>

- (void)ZJCollectionViewPageFlowLayout:(ZJCollectionViewPageFlowLayout *)layout scrolleToIndex:(NSInteger)index;

@end
@interface ZJCollectionViewPageFlowLayout : UICollectionViewFlowLayout

- (instancetype)initWithSectionInset:(UIEdgeInsets)insets andMiniInterItemSpace:(CGFloat)miniInterItemSpace andItemSize:(CGSize)itemSize;
@end
