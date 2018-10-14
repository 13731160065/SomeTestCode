//
//  main.m
//  macDemo
//
//  Created by 王泽众 on 2018/8/3.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZZSPECIALManager.h"
#import "WZZSPECIALHeader.h"
#import "StringClass.h"

//MARK:执行函数
void runFunc() {
    WZZFunc * func = [WZZFunc funcWithName:@"log" returnClass:nil];

}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSMutableString * str1 = [NSMutableString stringWithFormat:@"ffff2"];
        NSMutableString * str2 = [NSMutableString stringWithFormat:@"ffff"];
        NSLog(@"%p, %p", [str1 class], [str2 class]);
    }
    return 0;
}
