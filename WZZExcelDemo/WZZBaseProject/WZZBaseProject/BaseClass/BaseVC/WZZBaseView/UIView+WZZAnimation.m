//
//  UIView+WZZAnimation.m
//  WZZBaseProject
//
//  Created by 王泽众 on 2018/6/26.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "UIView+WZZAnimation.h"

@implementation UIView (WZZAnimation)

#pragma mark - launchPad
- (void)showLikeLaunchPadWithDuration:(NSTimeInterval)duration
                             complete:(void (^)(void))complete {
    self.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
    self.alpha = 0.0f;
    [UIView animateWithDuration:duration animations:^{
        self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        if (complete) {
            complete();
        }
    }];
}

- (void)dismissLikeLaunchPadDuration:(NSTimeInterval)duration
                            complete:(void (^)(void))complete {
    self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    self.alpha = 1.0f;
    [UIView animateWithDuration:duration animations:^{
        self.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        if (complete) {
            complete();
        }
    }];
}

@end
