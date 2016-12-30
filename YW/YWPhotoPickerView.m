//
//  YWPhotoPickerView.m    
//  YW_Camer
//
//  Created by yaowei1314cj on 16/12/21.
//  Copyright © 2016年 yaowei1314cj. All rights reserved.
//

#import "YWPhotoPickerView.h"

#define HPPZ  @"横屏拍照，更容易查看图片"
#define View_Alpha 0.3  //  控件的透明度

@interface YWPhotoPickerView ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIButton *_cancelBtn;
    UIButton *_photoBtn;
    UIButton *_picktureBtn;
}

@end

@implementation YWPhotoPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self initUI];
        [self tapToChangeFocus];
    }
    return self;
}

//    初始化UI;
- (void)initUI
{
    /**
     *  开灯关灯的BTN，注意时间节点控制。
     */
    UIButton *lightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    lightBtn.frame = CGRectMake( 10, 50, 36, 36);
    
    [lightBtn setBackgroundImage:[UIImage imageNamed:@"flash_light_img"] forState:0];
    [lightBtn setBackgroundImage:[UIImage imageNamed:@"flash_light_Selected_img"] forState:UIControlStateSelected];
    
    [lightBtn addTarget:self action:@selector(lightBtnClicks:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:lightBtn];
    
    CGFloat supViewH = 70;
    
    UIView *downAlphaView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - supViewH, self.bounds.size.width, supViewH)];
    [downAlphaView setBackgroundColor:[UIColor blackColor]];
    downAlphaView.alpha = View_Alpha;
    [self addSubview:downAlphaView];
    
    /**
     *  下面的View;
     */
    UIView *downSubView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - supViewH, self.bounds.size.width, supViewH)];
    [downSubView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:downSubView];
    
    CGFloat Width = self.frame.size.width;
    CGFloat Height = supViewH;
    CGFloat photoWidth = Height/1.25;
    
    _photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _photoBtn.frame = CGRectMake( Width/2 - photoWidth/2 , (Height - photoWidth)/2 , photoWidth, photoWidth);
    [_photoBtn setBackgroundImage:[UIImage imageNamed:@"camera_green_img"] forState:0];
    [_photoBtn addTarget:self action:@selector(takePictureToPush:) forControlEvents:UIControlEventTouchUpInside];
    [downSubView addSubview:_photoBtn];
    
    CGFloat cancelWidth = Height / 1.8;
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.frame = CGRectMake( photoWidth/3 , (Height - cancelWidth)/2 , cancelWidth, cancelWidth);
    [_cancelBtn addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"cancel_btn_img"] forState:0];
    [downSubView addSubview:_cancelBtn];
    
    _picktureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _picktureBtn.frame = CGRectMake(Width - photoWidth/3 - cancelWidth, (Height - cancelWidth)/2 , cancelWidth, cancelWidth);
    [_picktureBtn setTitle:@"相册" forState:0];
    [_picktureBtn setTitleColor:[UIColor whiteColor] forState:0];
    [_picktureBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_picktureBtn addTarget:self action:@selector(takeThePicktureClick) forControlEvents:UIControlEventTouchUpInside];
    _picktureBtn.layer.masksToBounds = YES;
    _picktureBtn.layer.cornerRadius = cancelWidth/2;
    _picktureBtn.backgroundColor = [UIColor blackColor];
    _picktureBtn.alpha = 0.5;
    [downSubView addSubview:_picktureBtn];
    
    /**
     *  加上的一段文字.
     */
    CGFloat labVHieght = 190;
    CGFloat labVWidth = 25;
    UIView *labView = [[UIView alloc] initWithFrame:CGRectMake(8, (self.bounds.size.height - labVHieght -supViewH)/2 , labVWidth, labVHieght)];
    labView.backgroundColor = [UIColor blackColor];
    labView.alpha = View_Alpha;
    labView.layer.masksToBounds = YES;
    labView.layer.cornerRadius = labVWidth / 5;
    [self addSubview:labView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labVHieght, labVWidth)];
    label.text = HPPZ;
    label.transform = CGAffineTransformMakeRotation( 90 * M_PI/180.0);
    label.center = labView.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [label setFont:[UIFont systemFontOfSize:15]];
    [self addSubview:label];
    
}

//  传过来的旋转按钮等操作。
- (void)setTheRotationTransform:(CGAffineTransform)transform
{
    [UIView animateWithDuration:0.25 animations:^{
        _cancelBtn.transform = transform;
        _photoBtn.transform = transform;
        _picktureBtn.transform = transform;
    }];
}


- (void)tapToChangeFocus
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapGestureRecognizer:)];
    [self addGestureRecognizer:tap];
}

/**
 *  对焦
 */
- (void)TapGestureRecognizer:(UITapGestureRecognizer *)tap
{
    UIView *vi = tap.view;
    CGPoint point = [tap locationInView:vi];
    
    if ([self.delegate respondsToSelector:@selector(tapToFocusWithPoint:)]) {
        [self.delegate tapToFocusWithPoint:point];
    }
}

/**
 *  闪光灯
 */
- (void)lightBtnClicks:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if ([self.delegate respondsToSelector:@selector(openOrCloseTheflash)]) {
        [self.delegate openOrCloseTheflash];
    }
}

/**
 *  确定拍照的按钮。
 */
- (void)takePictureToPush:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(takePictureToCut)]) {
        [self.delegate takePictureToCut];
    }
}

/**
 *  取消按钮
 */
- (void)cancelButtonClick
{
    if ([self.delegate respondsToSelector:@selector(cancelToTakePhoto)]) {
        [self.delegate cancelToTakePhoto];
    }
}

- (void)takeThePicktureClick
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagePicker.allowsEditing = NO;
        imagePicker.delegate = self;
        // 显示状态栏
        [UIApplication sharedApplication].statusBarHidden = NO;
        [[self viewController] presentViewController:imagePicker animated:YES completion:nil];
    } else {
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"获取相机失败" message:@"请去设置界面允许访问相册" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [al show];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{
    [[self viewController] dismissViewControllerAnimated:YES completion:nil];
    if ([self.delegate respondsToSelector:@selector(getThePicktuer:)]) {
        [self.delegate getThePicktuer:image];
    }
}

- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


@end

















