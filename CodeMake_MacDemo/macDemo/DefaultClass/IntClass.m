//
//  IntClass.m
//  macDemo
//
//  Created by 王泽众 on 2018/9/14.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "IntClass.h"
#import "WZZSPECIALHeader.h"
#import "NumberClass.h"

static WZZClass * IntClass_Int;

@implementation IntClass

+ (WZZClass *)getClass {
    IntClass_Int = [WZZClass classWithSuperClass:[NumberClass getClass] className:@"Int"];
    return IntClass_Int;
}

@end
