//
//  WZZChangeZhongTingVC.m
//  tmp3d
//
//  Created by 王泽众 on 2018/6/6.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZChangeZhongTingVC.h"

@interface WZZChangeZhongTingVC ()
@property (weak, nonatomic) IBOutlet UITextField *xyTF;

@end

@implementation WZZChangeZhongTingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_hv == WZZInsideNode_H) {
        _xyTF.placeholder = [NSString stringWithFormat:@"%.2lf<y<%.2lf", _min, _max];
    } else {
        _xyTF.placeholder = [NSString stringWithFormat:@"%.2lf<x<%.2lf", _min, _max];
    }
}

- (IBAction)okClick:(id)sender {
    [self.view endEditing:YES];
    if (_xyTF.text.doubleValue > _max || _xyTF.text.doubleValue < _min) {
        return;
    }
    if (_okBlock) {
        _okBlock(_xyTF.text.doubleValue);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)cancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
