//
//  YWShowTheCutPictureSupView.h
//  YW_Camer
//
//  Created by yaowei1314cj on 16/12/23.
//  Copyright © 2016年 yaowei1314cj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YWShowPictureDelegate <NSObject>

- (void)takeThisPicture:(UIImage *)image;

- (void)cancelTakeThisPicture;

@end

@interface YWShowTheCutPictureSupView : UIView

@property (nonatomic , copy) UIImage *image;

@property (nonatomic , assign) id <YWShowPictureDelegate>delegate;

- (void)setTheRotationTransform:(CGAffineTransform)transform;

@end
