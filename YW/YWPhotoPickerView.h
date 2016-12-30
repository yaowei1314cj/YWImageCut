//
//  YWPhotoPickerView.h
//  YW_Camer
//
//  Created by yaowei1314cj on 16/12/21.
//  Copyright © 2016年 yaowei1314cj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YWPhotoPickerDelegate <NSObject>

//  聚焦
- (void)tapToFocusWithPoint:(CGPoint)point;

//  开启/关闭 闪光灯
- (void)openOrCloseTheflash;

//  图片裁剪
- (void)takePictureToCut;

//  取消按钮
- (void)cancelToTakePhoto;

//  获取相机
- (void)getThePicktuer:(UIImage *)image;

@end

@interface YWPhotoPickerView : UIView

@property (nonatomic , assign) id<YWPhotoPickerDelegate>delegate;

- (void)setTheRotationTransform:(CGAffineTransform)transform;

@end
