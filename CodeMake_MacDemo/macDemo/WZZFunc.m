//
//  WZZFunc.m
//  macDemo
//
//  Created by 王泽众 on 2018/9/10.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZFunc.h"
#import "WZZSPECIALHeader.h"

@implementation WZZFunc

+ (instancetype)funcWithName:(NSString *)funcName
                 returnClass:(WZZClass *)returnClass {
    WZZFunc * func = [[WZZFunc alloc] init];
    func.name = funcName;
    func.returnClass = returnClass;
    return func;
}

- (WZZVar *)runFunc {
    for (int i = 0; i < self.runArray.count; i++) {
        WZZSentance * sent = self.runArray[i];
        if ([sent isKindOfClass:[WZZSentanceReturn class]]) {
            return [sent runSentance];
        } else {
            [sent runSentance];
        }
    }
    return nil;
}

- (NSString *)checkId {
    NSMutableString * str = [NSMutableString string];
    [str appendFormat:@"%@", self.name];
    if (self.varArray.count) {
        [str appendFormat:@"_"];
    }
    for (WZZVar * aVar in self.varArray) {
        [str appendFormat:@"%@:", aVar.descFunc];
    }
    return str;
}

@end
