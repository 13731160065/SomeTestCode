//
//  WZZChangeZhongTingVC.h
//  tmp3d
//
//  Created by 王泽众 on 2018/6/6.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZZShapeHandler.h"
#import "WZZZhongTingNode.h"

@interface WZZChangeZhongTingVC : UIViewController

/**
 挺方向
 */
@property (nonatomic, assign) WZZInsideNode_HV hv;

@property (nonatomic, assign) CGFloat max;
@property (nonatomic, assign) CGFloat min;

/**
 确定返回
 */
@property (nonatomic, strong) void(^okBlock)(CGFloat position);

@end
