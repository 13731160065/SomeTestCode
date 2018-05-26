//
//  WZZMakeQueueModel.h
//  tmp3d
//
//  Created by 王泽众 on 2018/5/25.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZZShapeHandler.h"

@interface WZZMakeQueueModel : NSObject

/**
 操作动作
 */
@property (nonatomic, assign) WZZInsideNode_Action action;

/**
 操作点
 */
@property (nonatomic, assign) CGPoint actionPoint;

/**
 操作node
 */
@property (nonatomic, strong) SCNNode * actionToNode;

@end
