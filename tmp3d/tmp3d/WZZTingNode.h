//
//  WZZTingNode.h
//  tmp3d
//
//  Created by 王泽众 on 2018/5/25.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import "WZZShapeHandler.h"

@interface WZZTingNode : SCNNode

/**
 挺的方向
 */
@property (nonatomic, assign) WZZInsideNode_HV tingHV;

/**
 相连的挺
 */
@property (nonatomic, strong) NSMutableArray <WZZTingNode *>* connectTing;



@end
