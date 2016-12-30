//
//  YWCommenTool.m
//  YW_Camer
//
//  Created by yaowei1314cj on 16/12/23.
//  Copyright © 2016年 yaowei1314cj. All rights reserved.
//

#import "YWCommenTool.h"
#import "YWPhotopickerViewController.h"

@interface YWCommenTool ()

@end

@implementation YWCommenTool

+ (YWPhotopickerViewController *)pushToVC:(UIViewController *)vc
{
    YWPhotopickerViewController * loginVC = [[YWPhotopickerViewController alloc] init];
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [vc.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [vc.navigationController pushViewController:loginVC animated:NO];
    return loginVC;
}


@end
