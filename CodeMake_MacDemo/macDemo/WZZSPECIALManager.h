//
//  WZZSPECIALManager.h
//  macDemo
//
//  Created by 王泽众 on 2018/9/10.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZZSPECIALBaseObject.h"

typedef enum : NSUInteger {
    WZZSPECIALManager_CodeType_OC,
    WZZSPECIALManager_CodeType_JAVA,
} WZZSPECIALManager_CodeType;//语言类型

typedef enum : NSUInteger {
    WZZSPECIALManager_Power_Public,//开放
    WZZSPECIALManager_Power_Protected,//保护
    WZZSPECIALManager_Power_Private,//私有
    WZZSPECIALManager_Power_Default = WZZSPECIALManager_Power_Protected,//默认
} WZZSPECIALManager_Power;

@interface WZZSPECIALManager : NSObject

/**
 用户名
 */
@property (nonatomic, strong) NSString * userName;

/**
 版权
 */
@property (nonatomic, strong) NSString * aCopyRight;

/**
 项目名
 */
@property (nonatomic, strong) NSString * projectName;

/**
 单例

 @return 实例
 */
+ (instancetype)shareInstance;

@end
