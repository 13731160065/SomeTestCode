//
//  ObjectClass.m
//  macDemo
//
//  Created by 王泽众 on 2018/9/14.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "ObjectClass.h"
#import "WZZSPECIALHeader.h"
#import "StringClass.h"

@implementation ObjectClass

+ (WZZClass *)objectClass {
    WZZClass * ObjectClass_Object = [[WZZClass alloc] init];
    ObjectClass_Object.className = @"Object";
    
    //alloc
    WZZClassFunc * func_alloc = [WZZClassFunc funcWithName:@"alloc" returnClass:nil];
    func_alloc.power = WZZSPECIALManager_Power_Public;
    func_alloc.runArray
    
    //        WZZObjectFunc * func1 = [WZZObjectFunc funcWithName:@"description" returnClass:[StringClass getClass]];
    //        WZZVar * s1v = [[WZZVar alloc] init];
    //        s1v.pointClass = [StringClass getClass];
    
    //        WZZSentanceReturn * s1 = [WZZSentanceReturn returnVar:<#(WZZVar *)#>]
    return ObjectClass_Object;
}

@end
