//
//  WZZWindowDataHandler.h
//  tmp3d
//
//  Created by 王泽众 on 2018/6/5.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZZTingNode.h"
#import "WZZWindowNode.h"

@interface WZZWindowDataHandler : NSObject

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

/**
 所有挺
 */
@property (nonatomic, strong) NSMutableArray <WZZTingNode *>* allTings;

/**
 当前选中挺
 */
@property (nonatomic, strong) WZZZhongTingNode * currentTing;

/**
 边框材质
 */
@property (nonatomic, strong) NSString * borderTexture;

/**
 根节点，暂时没赋值
 */
@property (nonatomic, strong) SCNNode * rootNode;

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
 记录当前编辑状态
 */
+ (void)markdownState;

/**
 撤销
 */
+ (WZZWindowNode *)undo;

/**
 重做
 */
+ (WZZWindowNode *)redo;

/**
 获取矩形所有边框数据
 */
- (void)getRectAllBorderData:(void(^)(id borderData))borderDataBlock;

#pragma mark - 数据存储重组

/**
 获取所有重建数据
 
 @return 重建数据字典
 */
+ (NSDictionary *)getAllMakerData;

/**
 重建所有窗体
 
 @param dic 数据字典
 */
+ (WZZWindowNode *)makeAllWindowWithDic:(NSDictionary *)dic;

/**
 获取insdieDic以修改

 @param dic 所有数据的字典
 @param insideLevel inside等级
 @return 找到的dic
 */
+ (NSMutableDictionary *)getInsideDicWithAllWindowDic:(NSDictionary *)dic
                                          insideLevel:(NSInteger)insideLevel;

@end
