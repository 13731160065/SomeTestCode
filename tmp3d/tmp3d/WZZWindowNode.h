//
//  WZZWindowNode.h
//  tmp3d
//
//  Created by 王泽众 on 2018/5/23.
//  Copyright © 2018年 王泽众. All rights reserved.
//  框，每个框中间有填充

#import <SceneKit/SceneKit.h>
#import "WZZInsideNode.h"
#import "WZZWindowDataMaker.h"

@interface WZZWindowNode : SCNNode

/**
 窗户数据
 */
@property (nonatomic, weak) WZZWindowDataMaker * windowMaker;

/**
 内部点，如果没边框，内部点和外部点相等
 */
@property (nonatomic, strong) NSArray <NSValue *>* insetPoints;

/**
 外部点
 */
@property (nonatomic, strong) NSArray <NSValue *>* outPoints;

/**
 内容
 */
@property (nonatomic, strong) WZZInsideNode * insideContent;

//框上可能没有，上下左右挺，没有上下左右某个挺的那面就是边框
/**
 上挺
 */
@property (nonatomic, strong) WZZTingNode * borderUpTing;

/**
 下挺
 */
@property (nonatomic, strong) WZZTingNode * borderDownTing;

/**
 左挺
 */
@property (nonatomic, strong) WZZTingNode * borderLeftTing;

/**
 右挺
 */
@property (nonatomic, strong) WZZTingNode * borderRightTing;

/**
 边框数组
 */
@property (nonatomic, strong) NSArray <WZZTingNode *>* borderTingArray;

/**
 是主框体
 */
@property (nonatomic, assign) BOOL isRootWindow;

/**
 窗体边框类型
 */
@property (nonatomic, assign) WZZShapeHandler_WindowBorderType windowBorderType;

/**
 创建window

 @param leftH 左边高
 @param rightH 右边高
 @param downWidth 下边宽
 @param windowBorderType 有没有框
 @return 实例
 */
+ (instancetype)nodeWithLeftHeight:(CGFloat)leftH
                       rightHeight:(CGFloat)rightH
                         downWidth:(CGFloat)downWidth
                  windowBorderType:(WZZShapeHandler_WindowBorderType)windowBorderType;

/**
 创建window
 
 @param height 左边高
 @param width 下边宽
 @param windowBorderType 有没有框
 @return 实例
 */
+ (instancetype)nodeWithHeight:(CGFloat)height
                         width:(CGFloat)width
              windowBorderType:(WZZShapeHandler_WindowBorderType)windowBorderType;

/**
 创建window

 @param points 点数组
 @param windowBorderType 边框类型
 @return 实例
 */
+ (instancetype)nodeWithPoints:(NSArray <NSValue *>*)points
              windowBorderType:(WZZShapeHandler_WindowBorderType)windowBorderType;

//点击
- (void)nodeClick:(SCNHitTestResult *)result;

//点击
- (void)nodeClickPoint:(CGPoint)result;


/**
 切换转向框状态
 ，只有转向框和无状态可以互相切换，主框不能切换状态
 @param turnBorderType 状态
 */
- (void)changeTurnBorderType:(WZZShapeHandler_WindowBorderType)turnBorderType;

@end
