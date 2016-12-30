//
//  ViewController.m
//  YWImageCut
//
//  Created by yaowei1314cj on 16/12/29.
//  Copyright © 2016年 yaowei1314cj. All rights reserved.
//

#import "ViewController.h"
#import "YWPhotopickerViewController.h"
#import "YWCommenTool.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一页" style:UIBarButtonItemStylePlain target:self action:@selector(pushToYWPhotopickerViewController)];
    
}

- (void)pushToYWPhotopickerViewController
{
    [[YWCommenTool pushToVC:self] letImageCut:^(UIImage *iamge) {
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage:iamge];
        imgView.frame = self.view.bounds;
        [self.view addSubview:imgView];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
