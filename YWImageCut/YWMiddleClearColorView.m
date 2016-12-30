//
//  YWMiddleClearColorView.m
//  YW_Camer
//
//  Created by yaowei1314cj on 16/12/26.
//  Copyright © 2016年 yaowei1314cj. All rights reserved.
//

#import "YWMiddleClearColorView.h"
#import "YWCutThePicture.h"

#define IMG_Width 25

#define IMG_2_Width IMG_Width*2

#define lineWidth 0.8

static CGFloat OldWidth = 0;
static CGFloat OldHeight = 0;
static CGFloat OldX = 0;
static CGFloat OldY = 0;
static CGRect rightRect;
static CGRect bottomRect;

@interface YWMiddleClearColorView ()<YWCutThePicktureDelegate>

@property (nonatomic , strong) UIImageView *topLeftImg;
@property (nonatomic , strong) UIImageView *topRightImg;
@property (nonatomic , strong) UIImageView *downLeftImg;
@property (nonatomic , strong) UIImageView *downRightImg;

@property (nonatomic , strong) YWCutThePicture *topLeftCutView;
@property (nonatomic , strong) YWCutThePicture *topMiddleCutView;
@property (nonatomic , strong) YWCutThePicture *topRightCutView;
@property (nonatomic , strong) YWCutThePicture *leftCutView;
@property (nonatomic , strong) YWCutThePicture *rightCutView;
@property (nonatomic , strong) YWCutThePicture *bottomLeftCutView;
@property (nonatomic , strong) YWCutThePicture *bottomMiddleCutView;
@property (nonatomic , strong) YWCutThePicture *bottomRightCutView;


@end

@implementation YWMiddleClearColorView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self takeMiddlePickture];
        
        [self addTheRoundPangestureGecognizer];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecogniz:)];
        [self addGestureRecognizer:pan];
        
    }
    return self;
}

/**
 *  添加四张图片
 */
- (void)takeMiddlePickture
{
    _topLeftImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_corner_1"]];
    _topLeftImg.userInteractionEnabled = YES;
    [self addSubview:_topLeftImg];
    
    _topRightImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_corner_2"]];
    _topRightImg.userInteractionEnabled = YES;
    [self addSubview:_topRightImg];
    
    _downLeftImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_corner_3"]];
    _downLeftImg.userInteractionEnabled = YES;
    [self addSubview:_downLeftImg];
    
    _downRightImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_corner_4"]];
    _downRightImg.userInteractionEnabled = YES;
    [self addSubview:_downRightImg];
}


/**
 *  添加8个触摸方式的View;
 */
- (void)addTheRoundPangestureGecognizer
{
    _topLeftCutView = [[YWCutThePicture alloc] init];
    _topLeftCutView.direction = canBothMove;
    _topLeftCutView.delegate = self;
    [self addSubview:_topLeftCutView];
    
    _topMiddleCutView = [[YWCutThePicture alloc] init];
    _topMiddleCutView.direction = canPortrait;
    _topMiddleCutView.delegate = self;
    [self addSubview:_topMiddleCutView];
    
    _topRightCutView = [[YWCutThePicture alloc] init];
    _topRightCutView.direction = canBothMove;
    _topRightCutView.delegate = self;
    [self addSubview:_topRightCutView];
    
    _leftCutView = [[YWCutThePicture alloc] init];
    _leftCutView.direction = canLandscape;
    _leftCutView.delegate = self;
    [self addSubview:_leftCutView];
    
    _rightCutView = [[YWCutThePicture alloc] init];
    _rightCutView.direction = canLandscape;
    _rightCutView.delegate = self;
    [self addSubview:_rightCutView];
    
    _bottomLeftCutView = [[YWCutThePicture alloc] init];
    _bottomLeftCutView.direction = canBothMove;
    _bottomLeftCutView.delegate = self;
    [self addSubview:_bottomLeftCutView];
    
    _bottomMiddleCutView = [[YWCutThePicture alloc] init];
    _bottomMiddleCutView.direction = canPortrait;
    _bottomMiddleCutView.delegate = self;
    [self addSubview:_bottomMiddleCutView];
    
    _bottomRightCutView = [[YWCutThePicture alloc] init];
    _bottomRightCutView.direction = canBothMove;
    _bottomRightCutView.delegate = self;
    [self addSubview:_bottomRightCutView];
    
}

- (void)resizeYWCutThePicktureBeginResize:(YWCutThePicture *)resizeControlView
{
    OldWidth = self.frame.size.width;
    OldHeight = self.frame.size.height;
    
    OldX = self.frame.origin.x;
    OldY = self.frame.origin.y;
    
    rightRect = [self.superview convertRect:_rightCutView.frame fromView:self];
    
    bottomRect = [self.superview convertRect:_bottomMiddleCutView.frame fromView:self];
    
}

//- (CGFloat)topXWithResizeControlView:(YWCutThePicture *)resizeControlView
//{
//    if (OldX + resizeControlView.translation.x < 0) {
//        return 0;
//    } else {
//        return OldX + resizeControlView.translation.x;
//    }
//}
//- (CGFloat)topYWithResizeControlView:(YWCutThePicture *)resizeControlView
//{
//    if (OldY + resizeControlView.translation.y < 0) {
//        return 0;
//    } else {
//        return OldY + resizeControlView.translation.y ;
//    }
//}
//- (CGFloat)topWidthWithResizeControlView:(YWCutThePicture *)resizeControlView
//{
//    if (OldWidth - resizeControlView.translation.x > IMG_2_Width) {
//        return OldWidth - resizeControlView.translation.x ;
//    } else {
//        return IMG_2_Width;
//    }
//}
//- (CGFloat)topHeightWithResizeControlView:(YWCutThePicture *)resizeControlView
//{
//    if (OldHeight - resizeControlView.translation.y > IMG_2_Width) {
//        return OldHeight - resizeControlView.translation.y;
//    } else {
//        return IMG_2_Width;
//    }
//}

/**
 *  触碰过程 判断略艰难 . 如何完美封装。
 */
- (void)resizeYWCutThePicktureDidResize:(YWCutThePicture *)resizeControlView
{
    
    if (resizeControlView == _topLeftCutView) {
#pragma mark - 触碰到了左上
        
        CGFloat newX,newY,newHeight,newWidth;
        
        if (OldX + resizeControlView.translation.x < 0) {
            newX = 0;
        } else {
            newX = OldX + resizeControlView.translation.x;
        }
        
        if (OldY + resizeControlView.translation.y < 0) {
            newY = 0;
        } else {
            newY = OldY + resizeControlView.translation.y ;
        }
        
        if (OldWidth - resizeControlView.translation.x > IMG_2_Width) {
            newWidth = OldWidth - resizeControlView.translation.x ;
        } else {
            newWidth = IMG_2_Width;
        }
        
        if (OldHeight - resizeControlView.translation.y > IMG_2_Width) {
            newHeight = OldHeight - resizeControlView.translation.y;
        } else {
            newHeight = IMG_2_Width;
        }
        
        if (newY == 0) {
            newHeight = OldY + OldHeight;
        }
        
        if (newX == 0) {
            newWidth = OldX + OldWidth;
        }
        
        if (newHeight > self.superview.frame.size.height - OldY ) {
            newHeight = self.superview.frame.size.height - OldY;
        }
        
        if (newX + IMG_Width > rightRect.origin.x) {
            newX = rightRect.origin.x - IMG_Width;
        }
        
        if (newY + IMG_Width > bottomRect.origin.y) {
            newY = bottomRect.origin.y - IMG_Width;
        }
        
        self.frame = CGRectMake( newX , newY  , newWidth , newHeight);
        
    } else if (resizeControlView == _topMiddleCutView) {
#pragma mark - 触碰到了上中
        
        CGFloat newHeight;
        if (OldHeight - resizeControlView.translation.y > IMG_2_Width) {
            newHeight = OldHeight - resizeControlView.translation.y;
        } else {
            newHeight = IMG_2_Width;
        }
        
        CGFloat newY;
        if (OldY + resizeControlView.translation.y > 0) {
            newY = OldY + resizeControlView.translation.y;
        } else {
            newY = 0;
        }
        if (newY == 0) {
            newHeight = OldY + OldHeight;
        }
        
        if (newY + IMG_Width > bottomRect.origin.y) {
            newY = bottomRect.origin.y - IMG_Width;
        }
        
        self.frame = CGRectMake( OldX , newY , OldWidth , newHeight);
        
    } else if (resizeControlView == _topRightCutView) {
#pragma mark - 触碰到了右上
        
        CGFloat newY,newHeight,newWidth;
        
        if (OldY + resizeControlView.translation.y < 0) {
            newY = 0;
        } else {
            newY = OldY + resizeControlView.translation.y ;
        }
        
        if (OldWidth + resizeControlView.translation.x > IMG_2_Width) {
            newWidth = OldWidth + resizeControlView.translation.x ;
        } else {
            newWidth = IMG_2_Width;
        }
        
        if (OldX + newWidth > self.superview.frame.size.width) {
            newWidth = self.superview.frame.size.width - OldX;
        }
        
        if (OldHeight - resizeControlView.translation.y > IMG_2_Width) {
            newHeight = OldHeight - resizeControlView.translation.y;
        } else {
            newHeight = IMG_2_Width;
        }
        
        if (newY == 0) {
            newHeight = OldY + OldHeight;
        }
        if (newY + IMG_Width > bottomRect.origin.y) {
            newY = bottomRect.origin.y - IMG_Width;
        }
        
        self.frame = CGRectMake( OldX , newY  , newWidth , newHeight);
        
    } else if (resizeControlView == _leftCutView) {
#pragma mark - 触碰到了左
        
        CGFloat newX,newWidth;
        
        if (OldX + resizeControlView.translation.x < 0) {
            newX = 0;
        } else {
            newX = OldX + resizeControlView.translation.x;
        }
        
        if (OldWidth - resizeControlView.translation.x > IMG_2_Width) {
            newWidth = OldWidth - resizeControlView.translation.x ;
        } else {
            newWidth = IMG_2_Width;
        }
        
        if (newX == 0) {
            newWidth = OldX + OldWidth;
        }
        
        if (newX + IMG_Width > rightRect.origin.x) {
            newX = rightRect.origin.x - IMG_Width;
        }
        
        self.frame = CGRectMake( newX , OldY , newWidth , OldHeight);
        
    } else if (resizeControlView == _rightCutView) {
#pragma mark - 触碰到了右
        CGFloat newWidth;
        
        if (resizeControlView.translation.x + OldWidth > IMG_2_Width) {
            newWidth = resizeControlView.translation.x + OldWidth;
        } else {
            newWidth = IMG_2_Width;
        }
        if ( newWidth + OldX > self.superview.frame.size.width) {
            newWidth = self.superview.frame.size.width - OldX;
        }
        self.frame = CGRectMake( OldX , OldY , newWidth , OldHeight);
        
    } else if (resizeControlView == _bottomLeftCutView) {
#pragma mark - 触碰到了左下
        
        CGFloat newX , newWidth , newHeight;
        
        if (OldX + resizeControlView.translation.x < 0) {
            newX = 0;
        } else {
            newX = OldX + resizeControlView.translation.x;
        }
        
        if (OldWidth - resizeControlView.translation.x > IMG_2_Width) {
            newWidth = OldWidth - resizeControlView.translation.x ;
        } else {
            newWidth = IMG_2_Width;
        }
        
        if ( OldHeight + resizeControlView.translation.y > IMG_2_Width) {
            newHeight = OldHeight + resizeControlView.translation.y;
        } else {
            newHeight = IMG_2_Width;
        }
        
        if (newX == 0) {
            newWidth = OldX + OldWidth;
        }
        
        if (newHeight > self.superview.frame.size.height - OldY ) {
            newHeight = self.superview.frame.size.height - OldY;
        }
        
        if (newX + IMG_Width > rightRect.origin.x) {
            newX = rightRect.origin.x - IMG_Width;
        }
        
        self.frame = CGRectMake( newX , OldY , newWidth , newHeight );
        
    } else if (resizeControlView == _bottomMiddleCutView) {
#pragma mark - 触碰到了中下
        
        CGFloat newHeight;
        
        if ( OldHeight + resizeControlView.translation.y > IMG_2_Width) {
            newHeight = OldHeight + resizeControlView.translation.y;
        } else {
            newHeight = IMG_2_Width;
        }
        
        if (newHeight > self.superview.frame.size.height - OldY ) {
            newHeight = self.superview.frame.size.height - OldY;
        }
        
        self.frame = CGRectMake( OldX , OldY , OldWidth , newHeight );
        
        
    } else if (resizeControlView == _bottomRightCutView) {
#pragma mark - 触碰到了右下
        
        CGFloat newWidth , newHeight;
        
        
        if ( OldWidth + resizeControlView.translation.x > IMG_2_Width) {
            newWidth = OldWidth + resizeControlView.translation.x ;
        } else {
            newWidth = IMG_2_Width;
        }
        
        if ( OldHeight + resizeControlView.translation.y > IMG_2_Width) {
            newHeight = OldHeight + resizeControlView.translation.y;
        } else {
            newHeight = IMG_2_Width;
        }
        
        if ( newWidth + OldX > self.superview.frame.size.width) {
            newWidth = self.superview.frame.size.width - OldX;
        }
        
        if (newHeight > self.superview.frame.size.height - OldY ) {
            newHeight = self.superview.frame.size.height - OldY;
        }
        
        self.frame = CGRectMake( OldX , OldY , newWidth , newHeight);
    }
    
    if ([self.delegate respondsToSelector:@selector(changeThisViewFrame:)]) {
        [self.delegate changeThisViewFrame:self];
    }
    
}

/**
 *  自己的滑动手势。
 */
- (void)panGestureRecogniz:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.superview];

    CGFloat pointX ,pointY;
    
    //  左 右约束
    if ( self.center.x + translation.x < self.bounds.size.width/2)
    {
        pointX = self.bounds.size.width/2;
    } else if ( self.center.x + translation.x > self.superview.frame.size.width - self.bounds.size.width/2)
    {
        pointX = self.superview.frame.size.width - self.bounds.size.width/2;
    } else {
        pointX = self.center.x + translation.x;
    }
    
    //  上 下约束
    if ( self.center.y + translation.y < self.bounds.size.height/2) {
        pointY = self.bounds.size.height/2;
    } else if ( self.center.y + translation.y > self.superview.frame.size.height - self.bounds.size.height/2)
    {
        pointY = self.superview.frame.size.height - self.bounds.size.height/2;
    } else {
        pointY = self.center.y + translation.y;
    }
    
    
    recognizer.view.center = CGPointMake( pointX, pointY);
    [recognizer setTranslation:CGPointZero inView:self.superview];
    
    if ([self.delegate respondsToSelector:@selector(changeThisViewFrame:)]) {
        [self.delegate changeThisViewFrame:self];
    }
}


/**
 *  超出父视图的解决方案
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!self.clipsToBounds && !self.hidden && self.alpha > 0) {
        UIView *result = [super hitTest:point withEvent:event];
        if (result) {
            return result;
        } else {
            
            for (UIView *subView in self.subviews.reverseObjectEnumerator) {
                CGPoint subPoint = [subView convertPoint:point fromView:self];
                result = [subView hitTest:subPoint withEvent:event];
                
                if (result) {
                    return result;
                }
            }
        }
    }
    return nil;
}



- (void)layoutSubviews
{
    
    for (UIView *view in self.subviews) {
        if ([view class] == [UIView class]) {
            [view removeFromSuperview];
        }
    }
    
    _topLeftImg.frame = CGRectMake(0, 0, IMG_Width, IMG_Width);
    
    _topRightImg.frame = CGRectMake(self.bounds.size.width - IMG_Width, 0, IMG_Width, IMG_Width);
    
    _downLeftImg.frame = CGRectMake(0, self.bounds.size.height - IMG_Width, IMG_Width, IMG_Width);
    
    _downRightImg.frame = CGRectMake(self.bounds.size.width - IMG_Width, self.bounds.size.height - IMG_Width, IMG_Width, IMG_Width);
    
    CGFloat Width = self.bounds.size.width;
    CGFloat Heigth = self.bounds.size.height;
    
    for (NSInteger i = 1; i < 3; i++) {
        
        UIView *widthLayer = [[UIView alloc] init];
        widthLayer.frame = CGRectMake(Width *i/3 - lineWidth/2, 0, lineWidth, Heigth);
        widthLayer.backgroundColor = [UIColor whiteColor];
        [self addSubview:widthLayer];
        
        UIView *heightLayer = [[UIView alloc] init];
        heightLayer.frame = CGRectMake( 0, Heigth *i/3 - lineWidth/2, Width, lineWidth);
        heightLayer.backgroundColor = [UIColor whiteColor];
        [self addSubview:heightLayer];
    }
    
    self.layer.borderWidth = lineWidth;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _topLeftCutView.frame = CGRectMake( -IMG_Width, -IMG_Width, IMG_2_Width, IMG_2_Width);
    
    _topMiddleCutView.frame = CGRectMake( IMG_Width, -IMG_Width, self.bounds.size.width - IMG_2_Width, IMG_2_Width);
    
    _topRightCutView.frame = CGRectMake( self.bounds.size.width - IMG_Width, -IMG_Width, IMG_2_Width, IMG_2_Width);
    
    _leftCutView.frame = CGRectMake( -IMG_Width, IMG_Width, IMG_2_Width, self.bounds.size.height - IMG_2_Width);
    
    _rightCutView.frame = CGRectMake(self.bounds.size.width - IMG_Width, IMG_Width, IMG_2_Width, self.bounds.size.height - IMG_2_Width);
    
    _bottomLeftCutView.frame = CGRectMake( -IMG_Width, self.bounds.size.height - IMG_Width, IMG_2_Width, IMG_2_Width);
    
    _bottomMiddleCutView.frame = CGRectMake( IMG_Width, self.bounds.size.height - IMG_Width, self.bounds.size.width - IMG_2_Width, IMG_2_Width);
    
    _bottomRightCutView.frame = CGRectMake( self.bounds.size.width - IMG_Width, self.bounds.size.height - IMG_Width, IMG_2_Width, IMG_2_Width);
    
}


@end

















