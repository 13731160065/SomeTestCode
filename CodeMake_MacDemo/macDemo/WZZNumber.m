//
//  WZZNumber.m
//  macDemo
//
//  Created by 王泽众 on 2018/9/12.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZNumber.h"
#import "WZZSPECIALHeader.h"

@implementation WZZNumber

+ (instancetype)numberWithNumber:(NSNumber *)number {
    return [self numberWithNumber:number type:WZZNumber_Type_Auto];
}

+ (instancetype)numberWithNumber:(NSNumber *)number type:(WZZNumber_Type)type {
    WZZNumber * aNumber = [[WZZNumber alloc] init];
    aNumber.realNumber = number;
    aNumber.type = type;
    return aNumber;
}

@end
