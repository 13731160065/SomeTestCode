//
//  WZZClass.h
//  macDemo
//
//  Created by 王泽众 on 2018/9/10.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZZSPECIALManager.h"
@class WZZProperty;
@class WZZFunc;


@interface WZZClass : WZZSPECIALBaseObject

/**
 父类
 */
@property (nonatomic, strong) WZZClass * superClass;

/**
 类名
 */
@property (nonatomic, strong) NSString * className;

/**
 属性数组
 */
@property (nonatomic, strong) NSMutableArray <WZZProperty *>* propertyArray;

/**
 类方法数组
 */
@property (nonatomic, strong) NSMutableArray <WZZFunc *>* classFuncArray;

/**
 对象方法数组
 */
@property (nonatomic, strong) NSMutableArray <WZZFunc *>* objFuncArray;

/**
 生成实例

 @param superClass 父类
 @param className 类名
 @return 类
 */
+ (instancetype)classWithSuperClass:(WZZClass *)superClass
                          className:(NSString *)className;

/**
 生成代码

 @param codeType 语言
 @return 代码，以文件名为key，文件内容为value
 */
- (NSDictionary <NSString *, NSData *>*)makeCode:(WZZSPECIALManager_CodeType)codeType;

@end
