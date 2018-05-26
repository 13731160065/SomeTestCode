//
//  WZZLinkedArray.h
//  tmp3d
//
//  Created by 王泽众 on 2018/5/24.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WZZLinkedObject;

typedef enum : NSUInteger {
    WZZLinkedObject_Index_Middle,//中间
    WZZLinkedObject_Index_First,//第一个
    WZZLinkedObject_Index_Last//最后节点
} WZZLinkedObjectIndex;

//链表数组
@interface WZZLinkedArray : NSObject

/**
 链表数组
 */
@property (nonatomic, strong) NSArray <WZZLinkedObject *>* array;

/**
 创建链表

 @param array 数组
 @return 实例
 */
+ (instancetype)arrayWithArray:(NSArray *)array;

@end

//链表元素
@interface WZZLinkedObject : NSObject

/**
 元素类型
 */
@property (nonatomic, assign) WZZLinkedObjectIndex indexType;

@property (nonatomic, weak) WZZLinkedObject * lastObj;
@property (nonatomic, weak) WZZLinkedObject * nextObj;
@property (nonatomic, weak) id thisObj;

@end
