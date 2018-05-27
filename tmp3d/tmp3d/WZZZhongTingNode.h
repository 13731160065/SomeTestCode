//
//  WZZZhongTingNode.h
//  tmp3d
//
//  Created by 王泽众 on 2018/5/27.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZTingNode.h"
#import "WZZShapeHandler.h"

@interface WZZZhongTingNode : WZZTingNode


/**
 挺的方向
 */
@property (nonatomic, assign, readonly) WZZInsideNode_HV tingHV;

/**
 创建中挺
 
 @param pointArr 点数组
 @param tingHV 方向
 @param border 宽度
 @return 挺
 */
+ (instancetype)nodeWithPath:(NSArray <NSValue *>*)pointArr
                   superNode:(SCNNode *)superNode
                      tingHV:(WZZInsideNode_HV)tingHV
                      border:(CGFloat)border;

@end
