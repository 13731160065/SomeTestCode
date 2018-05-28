//
//  WZZCalParamVC.m
//  tmp3d
//
//  Created by 王泽众 on 2018/5/28.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZCalParamVC.h"
#import "WZZShapeHandler.h"

@interface WZZCalParamVC ()

@property (weak, nonatomic) IBOutlet UITextView *mainTextView;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@end

@implementation WZZCalParamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_mainImageView setImage:_image];
    [_mainImageView setContentMode:UIViewContentModeScaleAspectFit];
    _mainImageView.layer.borderColor = [UIColor blackColor].CGColor;
    _mainImageView.layer.borderWidth = 1.0f;
    
    [[WZZShapeHandler shareInstance] getRectAllBorderData:^(id borderData) {
        _mainTextView.text = [NSString stringWithFormat:@"\n压线尺寸:\n%@\n玻璃尺寸\n%@\n中挺尺寸\n%@", borderData[@"line"], borderData[@"glass"], borderData[@"zhongTing"]];
    }];
}

- (IBAction)closeClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
