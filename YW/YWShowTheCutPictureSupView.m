//
//  YWShowTheCutPictureSupView.m
//  YW_Camer
//
//  Created by yaowei1314cj on 16/12/23.
//  Copyright © 2016年 yaowei1314cj. All rights reserved.
//

#import "YWShowTheCutPictureSupView.h"
#import "YWMiddleClearColorView.h"

#import "UIImage+PECrop.h"

#define View_Alpha 0.6  //  下部控件的透明度
#define supViewH 70     //  下面控件的高度

#define LEFT 30         //  裁剪框和图片的左边距离
#define TOP  30         //  裁剪框和图片的上边距离

@interface YWShowTheCutPictureSupView ()<YWMiddleClearViewDelegate>
{
    /**
     *  底部按钮。
     */
    UIButton *_agreeBtn;
    UIButton *_cancelBtn;
    
    /**
     *  周围四边的半透明View;
     */
    UIView *_topAlphaView;
    UIView *_leftAlphaView;
    UIView *_rightAlphaView;
    UIView *_bottomAlphaView;
    
    UIImageView *_imgView;
    
    YWMiddleClearColorView *_middleView;  //  中间的裁剪框。
    
}

@end

@implementation YWShowTheCutPictureSupView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setBackgroundColor:[UIColor blackColor]];
        
        [self initBaseUI];
        
    }
    return self;
}

- (void)initBaseUI
{
    [self setIndexImageView];
    
    [self roundAlphaView];
    
    [self agreeOrCancelView];
}

- (void)setIndexImageView
{
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT, TOP, self.bounds.size.width - LEFT*2 , self.bounds.size.height - TOP*2 - supViewH)];
    _imgView.contentMode = UIViewContentModeScaleAspectFit;
    _imgView.userInteractionEnabled = YES;
    [self addSubview:_imgView];
}

- (void)setImage:(UIImage *)image
{
    
    _image = image;
    
    _imgView.image = _image;
    _imgView.frame = CGRectZero;
    
    //  先恢复一下iamgeView的原始尺寸。
    CGRect imgOldFrame = CGRectMake(LEFT, TOP, self.bounds.size.width - LEFT*2 , self.bounds.size.height - TOP*2 - supViewH);
    
    CGFloat imageWidth = image.size.width;
    CGFloat imagHeight = image.size.height;
    
    CGFloat widthToHeight = imgOldFrame.size.height / imgOldFrame.size.width;
    
    CGFloat imgWidthToHeight = imagHeight/imageWidth;
    
    BOOL maxIsHeight = (imgWidthToHeight > widthToHeight) ? YES : NO ;
    
    CGFloat newImgViewHeight , newImgViewWidth;
    
    if (maxIsHeight) {
        
        newImgViewHeight = imgOldFrame.size.height;
        newImgViewWidth = widthToHeight * imgOldFrame.size.width/ imgWidthToHeight;
    } else {
        
        newImgViewWidth = imgOldFrame.size.width;
        newImgViewHeight = imgWidthToHeight * imgOldFrame.size.height/ widthToHeight;
    }
    
    _imgView.frame = CGRectMake((self.bounds.size.width - newImgViewWidth)/2, imgOldFrame.origin.y + (imgOldFrame.size.height - newImgViewHeight)/2 , newImgViewWidth, newImgViewHeight);
    
}


/**
 *  周围的半透明图片。
 */
- (void)roundAlphaView
{
    _topAlphaView = [[UIView alloc] init];
    _topAlphaView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:View_Alpha];
    _topAlphaView.userInteractionEnabled = YES;
    [_imgView addSubview:_topAlphaView];
    
    _leftAlphaView = [[UIView alloc] init];
    _leftAlphaView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:View_Alpha];
    _leftAlphaView.userInteractionEnabled = YES;
    [_imgView addSubview:_leftAlphaView];
    
    _rightAlphaView = [[UIView alloc] init];
    _rightAlphaView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:View_Alpha];
    _rightAlphaView.userInteractionEnabled = YES;
    [_imgView addSubview:_rightAlphaView];
    
    _bottomAlphaView = [[UIView alloc] init];
    _bottomAlphaView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:View_Alpha];
    _bottomAlphaView.userInteractionEnabled = YES;
    [_imgView addSubview:_bottomAlphaView];
    
    _middleView = [[YWMiddleClearColorView alloc] initWithFrame:_imgView.bounds];
    _middleView.delegate = self;
    [_imgView addSubview:_middleView];
    
}

- (void)changeThisViewFrame:(YWMiddleClearColorView *)view
{
    
    [self layoutOverlayViewsWithCropRect:view.frame];
}

/**
 *  下面的同意/返回的按钮。
 */
- (void)agreeOrCancelView
{
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
    
    _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _agreeBtn.frame = CGRectMake( Width/2 - photoWidth/2 , (Height - photoWidth)/2 , photoWidth, photoWidth);
    [_agreeBtn setBackgroundImage:[UIImage imageNamed:@"sure_usePic_img"] forState:0];
    [_agreeBtn addTarget:self action:@selector(takePictureToShow:) forControlEvents:UIControlEventTouchUpInside];
    [downSubView addSubview:_agreeBtn];
    
    CGFloat cancelWidth = Height / 1.8;
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.frame = CGRectMake( photoWidth/3 , (Height - cancelWidth)/2 , cancelWidth, cancelWidth);
    [_cancelBtn addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"cancel_btn_img"] forState:0];
    [downSubView addSubview:_cancelBtn];
    
}

- (void)setTheRotationTransform:(CGAffineTransform)transform
{
    [UIView animateWithDuration:0.25 animations:^{
        _cancelBtn.transform = transform;
        _agreeBtn.transform = transform;
    }];
}

/**
 *  获取该图片
 */
- (void)takePictureToShow:(UIButton *)btn
{
    UIImage *cropImage = [_imgView.image rotatedImageWithtransform:CGAffineTransformMakeRotation( 0 * M_PI/180.0) croppedToRect:[self cropAreaInImage]];
    
    if ([self.delegate respondsToSelector:@selector(takeThisPicture:)]) {
        //  获取这张图片  nil改成UIimage
        [self.delegate takeThisPicture:cropImage];
    }
    
#pragma mark - 最终获取到的图片。
    
//    [self setImage:cropImage];
}

/**
 *由于image在imageview中是缩放过的，这里要根据裁剪区域在imageview的尺寸换算
 *出对应的裁剪区域在实际image的尺寸
 */
- (CGRect)cropAreaInImage {
    
    CGFloat imageScaleWW = _imgView.image.size.width / _imgView.bounds.size.width;
    CGFloat imageScaleHH = _imgView.image.size.height / _imgView.bounds.size.height;
    
    CGFloat X = _middleView.frame.origin.x * imageScaleWW;
    CGFloat Y = _middleView.frame.origin.y * imageScaleHH;
    CGFloat Width = _middleView.frame.size.width * imageScaleWW;
    CGFloat Height = _middleView.frame.size.height * imageScaleHH;
    
    return CGRectMake(X, Y, Width, Height);
    
}




/**
 *  取消按钮
 */
- (void)cancelButtonClick
{
    if ([self.delegate respondsToSelector:@selector(cancelTakeThisPicture)]) {
        [self.delegate cancelTakeThisPicture];
    }
}

- (void)layoutSubviews
{
    _middleView.frame = CGRectMake( LEFT, TOP, _imgView.bounds.size.width - LEFT *2, _imgView.bounds.size
                                   .height - TOP * 2);
    [self layoutOverlayViewsWithCropRect:_middleView.frame];
    
}

- (void)layoutOverlayViewsWithCropRect:(CGRect)cropRect
{
    _topAlphaView.frame = CGRectMake(0.0f,
                                     0.0f,
                                     CGRectGetWidth(self.bounds),
                                     CGRectGetMinY(cropRect));
    
    _leftAlphaView.frame = CGRectMake(0.0f,
                                      CGRectGetMinY(cropRect),
                                      CGRectGetMinX(cropRect),
                                      CGRectGetHeight(cropRect));
    
    _rightAlphaView.frame = CGRectMake(CGRectGetMaxX(cropRect),
                                       CGRectGetMinY(cropRect),
                                       CGRectGetWidth(self.bounds) - CGRectGetMaxX(cropRect),
                                       CGRectGetHeight(cropRect));
    
    _bottomAlphaView.frame = CGRectMake(0.0f,
                                        CGRectGetMaxY(cropRect),
                                        CGRectGetWidth(self.bounds),
                                        CGRectGetHeight(self.bounds) - CGRectGetMaxY(cropRect));
    
}


@end















