//
//  WZZProperty.h
//  macDemo
//
//  Created by 王泽众 on 2018/9/10.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZZSPECIALManager.h"
@class WZZClass;
@class WZZObject;

@interface WZZProperty : WZZSPECIALBaseObject

/**
 类
 */
@property (nonatomic, strong) WZZClass * type;

/**
 对象
 */
@property (nonatomic, strong) WZZObject * obj;

/**
 访问权限
 */
@property (nonatomic, assign) WZZSPECIALManager_Power power;

@end
