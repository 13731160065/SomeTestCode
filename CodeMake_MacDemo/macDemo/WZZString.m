//
//  WZZString.m
//  macDemo
//
//  Created by 王泽众 on 2018/9/12.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZString.h"
#import "WZZSPECIALHeader.h"

@implementation WZZString

//MARK:实例化
+ (instancetype)stringWithString:(NSString *)string {
    WZZString * sss = [[WZZString alloc] init];
    sss.string = [NSString stringWithString:string];
    return sss;
}

@end
