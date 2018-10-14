//
//  WZZ2Tree.h
//  macDemo
//
//  Created by 王泽众 on 2018/8/22.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WZZ2TreeModel;

@interface WZZ2Tree : NSObject

/**
 生成树
 */
+ (void)treeWithRoot:(WZZ2TreeModel *)rootNode;

@end

@interface WZZ2TreeModel : NSObject

/**
 父节点
 */
@property (nonatomic, strong) WZZ2Tree * parentNode;

/**
 左子节点
 */
@property (nonatomic, strong) WZZ2Tree * leftChildNode;

/**
 右子节点
 */
@property (nonatomic, strong) WZZ2Tree * rightChildNode;

/**
 查询key
 */
@property (nonatomic, strong) NSString * key;

/**
 保存数据
 */
@property (nonatomic, strong) id value;

@end
