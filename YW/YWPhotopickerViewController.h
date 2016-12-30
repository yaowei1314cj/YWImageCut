//
//  YWPhotopickerViewController.h
//  YW_Camer
//
//  Created by yaowei1314cj on 16/12/21.
//  Copyright © 2016年 yaowei1314cj. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol YWPhotoPickerVCDelegate <NSObject>
//
//- (void)getPickture:(UIImage *)image;
//
//@end

typedef void(^imageCutBlock)(UIImage *iamge);

@interface YWPhotopickerViewController : UIViewController

//@property (nonatomic , assign) id <YWPhotoPickerVCDelegate>delegate;

@property (nonatomic , weak) imageCutBlock block;

- (void)letImageCut:(imageCutBlock)block;

@end
