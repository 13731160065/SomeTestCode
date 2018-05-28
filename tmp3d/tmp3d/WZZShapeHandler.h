//
//  WZZShapeHandler.h
//  tmp3d
//
//  Created by 王泽众 on 2018/5/24.
//  Copyright © 2018年 王泽众. All rights reserved.
//  处理整个门窗工程的类
/*
    所有路径、点数组，均按从(0,0)开始，逐个排列
 */

#import <Foundation/Foundation.h>
#import "WZZLinkedArray.h"

@class WZZTingNode;
@class WZZWindowNode;
@class WZZMakeQueueModel;
@import UIKit;
@import SceneKit;

//转换点，返回CGPoint
#define WZZShapeHandler_LinkedObjectToPoint(linkObj) [linkObj.thisObj CGPointValue]
#define WZZShapeHandlerTexture_Border @"lvhejin.jpg"
#define WZZShapeHandlerTexture_Fill @"boli.jpg"
#define WZZShapeHandler_mm_cm(cm) ((double)(cm)*10.0f)
#define WZZShapeHandler_mm_dm(dm) ((double)(dm)*100.0f)
#define WZZShapeHandler_mm_m(m) ((double)(m)*1000.0f)

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
 根节点
 */
@property (nonatomic, strong) SCNNode * rootNode;

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
 所有框
 包括层叠的大小框，需要进行筛选
 如果要重制请注意清空该数组
 */
@property (nonatomic, strong) NSMutableArray <WZZWindowNode *>* allWindows;

/**
 所有在最上层的window
 */
@property (nonatomic, strong, readonly) NSArray <WZZWindowNode *>* allUpWindows;

@property (nonatomic, strong) NSMutableArray <WZZTingNode *>* allTings;

/**
 单例

 @return 实例
 */
+ (instancetype)shareInstance;

/**
 重置handler
 */
+ (void)resetHandler;

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

/**
 获取矩形所有边框数据
 */
- (void)getRectAllBorderData:(void(^)(id borderData))borderDataBlock;

@end
