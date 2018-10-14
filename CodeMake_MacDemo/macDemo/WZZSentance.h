//
//  WZZSentance.h
//  macDemo
//
//  Created by 王泽众 on 2018/9/12.
//  Copyright © 2018年 王泽众. All rights reserved.
//  语句

#import "WZZSPECIALBaseObject.h"
#import "ObjectClass.h"
@class WZZVar;
@class WZZClass;
@class WZZObject;

@interface WZZSentance : WZZSPECIALBaseObject

@property (nonatomic, strong) void(^funcReturn)(id obj);

@property (nonatomic, strong) WZZObject * selfObj;
@property (nonatomic, strong) WZZClass * selfClass;

/**
 执行语句

 @return 执行结果
 */
- (id)runSentance;

@end
