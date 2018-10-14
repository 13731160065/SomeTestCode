//
//  DefaultClass.m
//  macDemo
//
//  Created by 王泽众 on 2018/9/14.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "DefaultClass.h"
#import "WZZSPECIALHeader.h"

@implementation DefaultClass

+ (WZZClass *)getClass {
    return nil;
}

+ (WZZObject *)object {
    return [WZZObject objectWithRealClass:[self getClass]];
}

@end
