//
//  YWPhotopickerViewController.m
//  YW_Camer
//
//  Created by yaowei1314cj on 16/12/21.
//  Copyright © 2016年 yaowei1314cj. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>

//#import <ImageIO/ImageIO.h>
//#import <CoreMedia/CoreMedia.h>


#import "YWPhotopickerViewController.h"
#import "YWPhotoPickerView.h"  //  拍照的时候的View
#import "YWShowTheCutPictureSupView.h"  //   拍照完成后，裁剪出现的View。


@interface YWPhotopickerViewController ()<YWPhotoPickerDelegate , YWShowPictureDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (nonatomic, strong) AVCaptureDevice *videoDevice;

@property (nonatomic, strong) AVCaptureDeviceInput *activeVideoInput;

@property (nonatomic, strong) AVCaptureStillImageOutput *imageOutput;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;

@property (nonatomic, strong) CMMotionManager *motionManager;

@property (nonatomic, assign) UIImageOrientation imageOtientation;

@property (nonatomic, weak)   YWPhotoPickerView *photo;

@property (nonatomic , strong) YWShowTheCutPictureSupView *cutPicSupView;

@end

@implementation YWPhotopickerViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    if (_motionManager == nil) {
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.deviceMotionUpdateInterval = 0.5;
        if (_motionManager.deviceMotionAvailable) {
            
            [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler: ^(CMDeviceMotion *motion, NSError *error){
                [self performSelectorOnMainThread:@selector(handleDeviceMotion:) withObject:motion waitUntilDone:YES];
            }];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    if (_motionManager) {
        [_motionManager stopDeviceMotionUpdates];
        _motionManager = nil;
    }
}
- (void)dealloc
{
    if (_motionManager) {
        [_motionManager stopDeviceMotionUpdates];
        _motionManager = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //  1、设置并开启相机；
    [self setUpCamer];
    
    //  2、给视图添加其他UI。
    [self createOtherUI];
    
    _cutPicSupView = [[YWShowTheCutPictureSupView alloc] initWithFrame:self.view.bounds];
    _cutPicSupView.hidden = YES;
    _cutPicSupView.delegate = self;
    [self.view addSubview:_cutPicSupView];
    
}

- (void)cancelTakeThisPicture
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        
        weakSelf.cutPicSupView.frame = CGRectMake(0, weakSelf.view.bounds.size.height, weakSelf.view.bounds.size.width, weakSelf.view.bounds.size.height);
        
    } completion:^(BOOL finished) {
        
        weakSelf.cutPicSupView.hidden = YES;
        weakSelf.cutPicSupView.frame = weakSelf.view.bounds;
        weakSelf.photo.hidden = NO;
    }];
}

- (void)takeThisPicture:(UIImage *)image
{
#warning  这个代理方法能获得到剪切出来的图片。 但是如何传给CommenTool呢。
//    if ([self.delegate respondsToSelector:@selector(getPickture:)]) {
//        [self.delegate getPickture:image];
//    }
    [self cancelToTakePhoto];
    
    if (self.block) {
        self.block(image);
    }
}

- (void)letImageCut:(imageCutBlock)block
{
    self.block = block;
}

- (void)handleDeviceMotion:(CMDeviceMotion *)deviceMotion{
    
    double x = deviceMotion.gravity.x;
    double y = deviceMotion.gravity.y;
    if (fabs(y) >= fabs(x)) {
        if (y >= 0) {
//            NSLog(@"UIDeviceOrientationPortraitUpsideDown");
            [self orientationChanged:UIDeviceOrientationPortraitUpsideDown];
        } else {
//            NSLog(@"UIDeviceOrientationPortrait");
            [self orientationChanged:UIDeviceOrientationPortrait];
        }
    } else {
        if (x >= 0) {
//            NSLog(@"UIDeviceOrientationLandscapeRight");
            [self orientationChanged:UIDeviceOrientationLandscapeRight];
        } else{
//            NSLog(@"UIDeviceOrientationLandscapeLeft");
            [self orientationChanged:UIDeviceOrientationLandscapeLeft];
        }
    }
}

- (void)orientationChanged:(UIDeviceOrientation)Orientation
{
    switch ( Orientation ) {
        case UIDeviceOrientationPortrait:            // Device oriented vertically, home button on the bottom
            _imageOtientation = UIImageOrientationRight;
            [self  rotation_icon:0.0];
            break;
        case UIDeviceOrientationPortraitUpsideDown:  // Device oriented vertically, home button on the top
            [self  rotation_icon:0.0];
            _imageOtientation = UIImageOrientationLeft;
            break;
        case UIDeviceOrientationLandscapeLeft:      // Device oriented horizontally, home button on the right
            [self  rotation_icon:90.0];
            _imageOtientation = UIImageOrientationUp;
            break;
        case UIDeviceOrientationLandscapeRight:      // Device oriented horizontally, home button on the left
            [self  rotation_icon:90.0 * 3];
            _imageOtientation = UIImageOrientationDown;
            break;
        default:
            break;
    }
}

-(void)rotation_icon:(float)n
{
    CGAffineTransform transform = CGAffineTransformMakeRotation(n*M_PI/180.0);
    
    [self.photo setTheRotationTransform:transform];
    [_cutPicSupView setTheRotationTransform:transform];
    
}

- (void)setUpCamer
{
    NSError *error = nil;
    
    self.captureSession = [[AVCaptureSession alloc] init];
    
    // Set up default camera device
    _videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    self.activeVideoInput = [AVCaptureDeviceInput deviceInputWithDevice:_videoDevice error:&error];
    if (self.activeVideoInput) {
        if ([self.captureSession canAddInput:self.activeVideoInput]) {
            [self.captureSession addInput:self.activeVideoInput];
        }
    }
    
    // Setup the still image output
    self.imageOutput = [[AVCaptureStillImageOutput alloc] init];
    self.imageOutput.outputSettings = @{AVVideoCodecKey : AVVideoCodecJPEG};
    
    if ([self.captureSession canAddOutput:self.imageOutput]) {
        [self.captureSession addOutput:self.imageOutput];
    }
    
    self.preview = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    self.preview.frame = self.view.bounds;
    [[self.preview connection] setVideoOrientation:AVCaptureVideoOrientationPortrait];
    [self.view.layer addSublayer:self.preview];
    [self startSession];
    
}

- (void)createOtherUI
{
    YWPhotoPickerView *photo = [[YWPhotoPickerView alloc] initWithFrame:self.view.bounds];
    photo.delegate = self;
    [self.view addSubview:photo];
    self.photo = photo;
}

//  聚焦
- (void)tapToFocusWithPoint:(CGPoint)point
{
    CGPoint newPoint;
    
    if (_preview) {
        newPoint = [_preview captureDevicePointOfInterestForPoint:point];
    } else {
        newPoint = point;
    }
    if (_videoDevice.isFocusPointOfInterestSupported &&
        [_videoDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError *error;
        if ([_videoDevice lockForConfiguration:&error]) {
            _videoDevice.focusPointOfInterest = newPoint;
            _videoDevice.focusMode = AVCaptureFocusModeAutoFocus;
            [_videoDevice unlockForConfiguration];
        }
    }
}

//  开启/关闭 闪光灯
- (void)openOrCloseTheflash
{
    //修改前必须先锁定
    [_videoDevice lockForConfiguration:nil];
    //必须判定是否有闪光灯，否则如果没有闪光灯会崩溃
    if ([_videoDevice hasFlash]) {

        if (_videoDevice.flashMode == AVCaptureFlashModeOff) {
            _videoDevice.flashMode = AVCaptureFlashModeOn;
            _videoDevice.torchMode = AVCaptureTorchModeOn;
        } else if (_videoDevice.flashMode == AVCaptureFlashModeOn) {
            _videoDevice.flashMode = AVCaptureFlashModeOff;
            _videoDevice.torchMode = AVCaptureTorchModeOff;
        }
    }
    [_videoDevice unlockForConfiguration];
}

- (void)getThePicktuer:(UIImage *)image
{
    [self takeThePicktureToCut:image];
}

//  图片裁剪
- (void)takePictureToCut
{
    AVCaptureConnection *myVideoConnection = nil;
    //从 AVCaptureStillImageOutput 中取得正确类型的 AVCaptureConnection
    for (AVCaptureConnection *connection in self.imageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                
                myVideoConnection = connection;
                break;
            }
        }
    }
    
    __weak typeof(self) weakSelf = self;
    //撷取影像（包含拍照音效）
    [self.imageOutput captureStillImageAsynchronouslyFromConnection:myVideoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        //完成撷取时的处理程序(Block)
        if (imageDataSampleBuffer) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            
            //取得的静态影像
            UIImage *myImage = [[UIImage alloc] initWithData:imageData];
            [weakSelf takeThePicktureToCut:myImage];
        }
    }];
}

- (void)takeThePicktureToCut:(UIImage *)image
{
    self.photo.hidden = YES;
    self.cutPicSupView.hidden = NO;
    self.cutPicSupView.image = image;
}

//  取消按钮
- (void)cancelToTakePhoto
{
    /**
     *  取消 -> 返回
     */
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:NO];
    [self stopSession];
    
    //修改前必须先锁定
    [_videoDevice lockForConfiguration:nil];
    //必须判定是否有闪光灯，否则如果没有闪光灯会崩溃
    if ([_videoDevice hasFlash]) {
        
        if (_videoDevice.flashMode == AVCaptureFlashModeOn) {
            _videoDevice.flashMode = AVCaptureFlashModeOff;
            _videoDevice.torchMode = AVCaptureTorchModeOff;
        }
    }
    [_videoDevice unlockForConfiguration];
}

- (void)startSession
{
    if (![self.captureSession isRunning]) {
        dispatch_async([self globalQueue], ^{
            [self.captureSession startRunning];
        });
    }
}

- (void)stopSession
{
    if ([self.captureSession isRunning]) {
        dispatch_async([self globalQueue], ^{
            [self.captureSession stopRunning];
        });
    }
}

- (dispatch_queue_t)globalQueue
{
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
}

@end




























