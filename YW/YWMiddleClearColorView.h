//
//  YWMiddleClearColorView.h
//  YW_Camer
//
//  Created by yaowei1314cj on 16/12/26.
//  Copyright © 2016年 yaowei1314cj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YWMiddleClearViewDelegate;

@interface YWMiddleClearColorView : UIView

@property (nonatomic , assign) id<YWMiddleClearViewDelegate>delegate;

@end

@protocol YWMiddleClearViewDelegate <NSObject>

- (void)changeThisViewFrame:(YWMiddleClearColorView *)view;

@end


