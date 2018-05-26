//
//  WZZShapeHandler.h
//  tmp3d
//
//  Created by 王泽众 on 2018/5/24.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZZLinkedArray.h"

@class WZZMakeQueueModel;
@import UIKit;
@import SceneKit;

//转换点，返回CGPoint
#define WZZShapeHandler_LinkedObjectToPoint(linkObj) [linkObj.thisObj CGPointValue]
#define WZZShapeHandlerTexture_Border @"lvhejin.jpg"
#define WZZShapeHandlerTexture_Fill @"boli.jpg"

typedef enum : NSUInteger {
    WZZInsideNodeContentType_None = 0,//没东西
    WZZInsideNodeContentType_Window,//框
    WZZInsideNodeContentType_Fill//填充
} WZZInsideNodeContentType;

typedef enum : NSUInteger {
    WZZInsideNode_V = 0,//垂直
    WZZInsideNode_H//水平
} WZZInsideNode_HV;//横纵

typedef enum : NSUInteger {
    WZZInsideNode_Action_None = 0,//无
    WZZInsideNode_Action_Cut,//切
    WZZInsideNode_Action_Fill//填充
} WZZInsideNode_Action;

typedef enum : NSUInteger {
    WZZInsideNodeFillType_None = 0,//没东西
    WZZInsideNodeFillType_Wood,//木头
    WZZInsideNodeFillType_Glass,//玻璃
    WZZInsideNodeFillType_Metal_Ai,//金属铝
    WZZInsideNodeFillType_Metal_Fe//金属铁
} WZZInsideNodeFillType;//内容填充材质

@interface WZZShapeHandler : NSObject

/**
 内容切割方向
 */
@property (nonatomic, assign) WZZInsideNode_HV insideHV;

/**
 内容动作
 */
@property (nonatomic, assign) WZZInsideNode_Action insideAction;

/**
 操作队列数组
 */
@property (nonatomic, strong) NSMutableArray <WZZMakeQueueModel *>* actionQueueArray;

/**
 单例

 @return 实例
 */
+ (instancetype)shareInstance;

/**
 创建边框，计算内边框位置

 @param linkArray 链表数组
 @param border 边框宽度
 @return 内边框位置
 */
+ (NSArray <NSValue *>*)makeBorderWithLinkArray:(WZZLinkedArray *)linkArray
                                         border:(CGFloat)border;

//创建三角形边框
+ (NSArray <NSValue *>*)makeBorder3WithLinkArray:(WZZLinkedArray *)linkArray
                                          border:(CGFloat)border;

//多边形
+ (NSArray <NSValue *>*)makeAnyBorderWithLinkArray:(WZZLinkedArray *)linkArray;

//计算多边形边框
+ (NSArray <NSValue *>*)makeAnyBorder2WithLinkArray:(WZZLinkedArray *)linkArray;

/**
 测试时快速显示点

 @param node 父node
 @param points 点
 @param color 颜色
 */
+ (void)showPointWithNode:(SCNNode *)node
                   points:(NSArray <NSValue *>*)points
                    color:(UIColor *)color;

@end
