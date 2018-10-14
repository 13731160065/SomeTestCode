//
//  StringClass.m
//  macDemo
//
//  Created by 王泽众 on 2018/9/14.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "StringClass.h"
#import "WZZSPECIALHeader.h"
#import "ObjectClass.h"

static WZZClass * StringClass_String;

@implementation StringClass

+ (WZZClass *)stringClass {
    StringClass_String = [WZZClass classWithSuperClass:[ObjectClass getClass] className:@"String"];
    return StringClass_String;
}

@end
