//
//  tmpViewController.m
//  WZZBaseProject
//
//  Created by 王泽众 on 2018/5/14.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "tmpViewController.h"
#import "SafeAreaDemoVC.h"
#include "xlsxwriter.h"
#import "WZZExcelManager.h"

@interface tmpViewController ()
{
    NSInteger number;
}
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;

@end

@implementation tmpViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"标题";
        number = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WZZBaseView * view2 = [[WZZBaseView alloc] initWithFrame:CGRectMake(DEF_SCREEN_WIDTH-50, DEF_SCREEN_HEIGHT-DEF_TABBAR_HEIGHT-50, 50, 50)];
    [self.view addSubview:view2];
    
    view2.backgroundColor = [UIColor greenColor];
    
    WZZBaseView * view3 = [[WZZBaseView alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
    [_rightLabel addSubview:view3];
    [view3 setBackgroundColor:[UIColor yellowColor]];
}

- (IBAction)next:(id)sender {
    tmpViewController * vc = [[tmpViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)test:(id)sender {
    
    NSString * path = [NSString stringWithFormat:@"%@/Documents/abc.xlsx", NSHomeDirectory()];
    
    NSArray * arr = @[
                      @[@"姓名", @"性别", @"手机"],
                      @[@"王泽众", @"男", @"12345"],
                      @[@"王乐乐", @"女", @"99988"]
                      ];
    
    WZZExcelManager * manager = [WZZExcelManager excel];
    
    WZZExcelSheet * sheetObj = [WZZExcelSheet sheetWithName:@"abc"];
    int i = 0;
    for (NSArray * arr2 in arr) {
        [sheetObj addOneColumn];
        for (NSString * str in arr2) {
            [sheetObj addOneRowToColumn:i dataStr:str];
        }
        i++;
    }
    
    manager.sheetArr = @[sheetObj];
    
    [manager saveAsFile:path complete:^(BOOL isOK, NSURL *fileUrl) {
        NSLog(@"excel:%@", fileUrl.absoluteString);
    }];
    
//    //创建新文件
//    lxw_workbook * workbook = workbook_new([path UTF8String]);
//    //创建sheet
//    lxw_worksheet * worksheet = workbook_add_worksheet(workbook, [@"sheet1" UTF8String]);
//    worksheet_set_column(worksheet, 4, 5, 100, NULL);
//    worksheet_write_string(worksheet, 0, 0, [@"1111" UTF8String], NULL);
//    worksheet_write_string(worksheet, 1, 0, [@"2222" UTF8String], NULL);
//
//    workbook_close(workbook);
    
//    if ([[NSFileManager defaultManager] isExecutableFileAtPath:[NSString stringWithFormat:@"%@", path]]) {
        NSLog(@"yes");
        UIDocumentInteractionController * vc = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:path]];
        [vc presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
//    } else {
//        NSLog(@"no");
//    }
    
//    SafeAreaDemoVC * vc = [[SafeAreaDemoVC alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
//    self.title = [self.title isEqualToString:@"一二三四五六七八九"]?@"标题":@"一二三四五六七八九";
    
//    self.basevc_navigationBarHidden = !self.basevc_navigationBarHidden;
//    [[WZZSingleManager shareInstance] changeWindowRoot:WZZSingleManager_ChangeWindowRoot_Tabbar];
//    [_topLabel wzz_startLoadingWithStyle:UIViewWZZLoading_Style_WiteBlack];
//    number++;
//    NSLog(@"开始加载%zd", number);
//    NSLog(@"%s", __func__);
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"结束加载:%zd", number);
//        [_topLabel wzz_endLoading];
//    });
}

@end
