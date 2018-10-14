//
//  NumberClass.m
//  macDemo
//
//  Created by 王泽众 on 2018/9/14.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "NumberClass.h"
#import "WZZSPECIALHeader.h"
#import "ObjectClass.h"

static WZZClass * NumberClass_Number;

@implementation NumberClass

+ (WZZClass *)getClass {
    NumberClass_Number = [WZZClass classWithSuperClass:[ObjectClass getClass] className:@"Number"];
    return NumberClass_Number;
}

@end
