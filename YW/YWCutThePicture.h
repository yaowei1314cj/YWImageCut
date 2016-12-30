//
//  YWCutThePicture.h
//  YW_Camer
//
//  Created by yaowei1314cj on 16/12/23.
//  Copyright © 2016年 yaowei1314cj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YWCutThePicktureDelegate;

typedef NS_ENUM(NSInteger, viewMoveDirection){
    
    canBothMove,    //  （四边的角都能移动）
    canLandscape,   //  只能横向移动
    canPortrait,    //  只能纵向移动
};

@interface YWCutThePicture : UIView

@property (nonatomic , assign) viewMoveDirection direction;

@property (nonatomic, readonly) CGPoint translation;

@property (nonatomic , assign) id <YWCutThePicktureDelegate>delegate;

@end

@protocol YWCutThePicktureDelegate <NSObject>

- (void)resizeYWCutThePicktureBeginResize:(YWCutThePicture *)resizeControlView;

- (void)resizeYWCutThePicktureDidResize:(YWCutThePicture *)resizeControlView;


@end
