//
//  WZZExcelManager.m
//  WZZBaseProject
//
//  Created by 王泽众 on 2018/10/10.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZExcelManager.h"
#import "xlsxwriter.h"

@implementation WZZExcelManager

+ (instancetype)excel {
    WZZExcelManager * man = [[WZZExcelManager alloc] init];
    return man;
}

//保存文件
- (void)saveAsFile:(NSString *)filePath
          complete:(void (^)(BOOL, NSURL *))complete {
    //子线程
    dispatch_queue_t tt = dispatch_queue_create("excelp", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(tt, ^{
        //创建xls
        lxw_workbook * book = workbook_new([filePath UTF8String]);
        
        //遍历表
        for (WZZExcelSheet * sheetObj in self.sheetArr) {
            //创建表
            lxw_worksheet * sheet = workbook_add_worksheet(book, [sheetObj.name UTF8String]);
            
            //列行遍历所有数据
            for (int col = 0; col < sheetObj.columnArr.count; col++) {
                NSMutableArray * rowArr = sheetObj.columnArr[col];
                for (int row = 0; row < rowArr.count; row++) {
                    //设置数据
                    NSString * str = sheetObj.columnArr[col][row];
                    worksheet_write_string(sheet, col, row, [str UTF8String], NULL);
                }
            }
        }
        
        //保存
        lxw_error error = workbook_close(book);
        
        //返回主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error == LXW_NO_ERROR) {
                //没有错误
                if (complete) {
                    complete(YES, [NSURL URLWithString:filePath]);
                }
            } else {
                //有错误
                if (complete) {
                    complete(NO, nil);
                }
            }
        });
    });
}

@end
