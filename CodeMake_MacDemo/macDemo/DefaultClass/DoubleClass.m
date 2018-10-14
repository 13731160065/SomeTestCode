//
//  DoubleClass.m
//  macDemo
//
//  Created by 王泽众 on 2018/9/14.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "DoubleClass.h"
#import "WZZSPECIALHeader.h"
#import "NumberClass.h"

static WZZClass * DoubleClass_Double;

@implementation DoubleClass

+ (WZZClass *)getClass {
    DoubleClass_Double = [WZZClass classWithSuperClass:[NumberClass getClass] className:@"Double"];
    return DoubleClass_Double;
}

@end
