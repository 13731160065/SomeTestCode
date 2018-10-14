//
//  BoolClass.m
//  macDemo
//
//  Created by 王泽众 on 2018/9/14.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "BoolClass.h"
#import "WZZSPECIALHeader.h"
#import "NumberClass.h"

static WZZClass * BoolClass_Bool;

@implementation BoolClass

+ (WZZClass *)getClass {
    BoolClass_Bool = [WZZClass classWithSuperClass:[NumberClass getClass] className:@"Bool"];
    return BoolClass_Bool;
}

@end
