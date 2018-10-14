//
//  WZZBaseValueClass.h
//  macDemo
//
//  Created by 王泽众 on 2018/9/14.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZSPECIALBaseObject.h"

@interface WZZBaseValueClass : WZZSPECIALBaseObject

/**
 真实字符串值
 和真实数字值同步
 该值为SPECIAL和OC数值沟通的桥梁
 */
@property (nonatomic, strong) NSString * realStringValue;

/**
 真实数字值
 和真实字符串值同步
 该值为SPECIAL和OC数值沟通的桥梁
 */
@property (nonatomic, strong) NSNumber * realNumberValue;

@end
