//
//  YWCutThePicture.m
//  YW_Camer
//
//  Created by yaowei1314cj on 16/12/23.
//  Copyright © 2016年 yaowei1314cj. All rights reserved.
//

#import "YWCutThePicture.h"

@interface YWCutThePicture ()

@property (nonatomic, readwrite) CGPoint translation;

@end

@implementation YWCutThePicture

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addTheProperty];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        [self addTheProperty];
    }
    return self;
}

- (void)addTheProperty
{
    self.userInteractionEnabled = YES;
    
//    self.backgroundColor = [UIColor orangeColor];
//    self.alpha = 0.6;
    
    self.backgroundColor = [UIColor clearColor];
    
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:gestureRecognizer];
}

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer
{
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        if ([self.delegate respondsToSelector:@selector(resizeYWCutThePicktureBeginResize:)]) {
            [self.delegate resizeYWCutThePicktureBeginResize:self];
        }
    } else {
        
        CGPoint translation = [gestureRecognizer translationInView:self.superview];
        
        switch (_direction) {
            case canBothMove:
                
                self.translation = CGPointMake( translation.x, translation.y);
                
                break;
            case canLandscape:
                
                self.translation = CGPointMake( translation.x , self.center.y);
                
                break;
            case canPortrait:
                
                self.translation = CGPointMake( self.center.x , translation.y );
                
                break;
                
            default:
                break;
        }
    
        if ([self.delegate respondsToSelector:@selector(resizeYWCutThePicktureDidResize:)]) {
            [self.delegate resizeYWCutThePicktureDidResize:self];
        }
        
    }
    
}

@end











