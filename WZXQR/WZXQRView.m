//
//  WZXQRView.m
//  Example
//
//  Created by WzxJiang on 16/12/6.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import "WZXQRView.h"

#define LINE_COLOR  [UIColor whiteColor]
#define LINE_LENGTH 16
#define LINE_WIDTH  4

@implementation WZXQRView {
    AVCaptureMetadataOutput * _output;
    UIView * _scanView;
    UIView * _boxView;
    NSTimer * _timer;
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
        [self createUI];
    }
    return self;
}

- (void)setUp {
    AVCaptureDevice * captureDevice =
    [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput * input =
    [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
    
    if (!input) {
        return;
    }
    
    _output =
    [[AVCaptureMetadataOutput alloc] init];
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    [_captureSession addOutput:_output];
    
    // TODO: - 扩展更多
    [_output setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];

    UIView * backgroundView = [UIView new];
    backgroundView.frame = self.bounds;
    backgroundView.backgroundColor = [UIColor blackColor];
    [_videoPreviewLayer setFrame:backgroundView.frame];
    [backgroundView.layer addSublayer:_videoPreviewLayer];
    [self addSubview:backgroundView];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval: 0.1 target:self selector:@selector(moveScanView) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void)createUI {
    CGFloat width = self.frame.size.width * 0.75;
    _boxView = [UIView new];
    _boxView.frame = CGRectMake((self.frame.size.width - width)/2.0,
                               (self.frame.size.height - width)/2.0, width, width);
    [self addSubview:_boxView];
    
    CAShapeLayer * lineLayer = [CAShapeLayer layer];
    
    UIBezierPath * path = [UIBezierPath bezierPath];

    [path moveToPoint:CGPointMake(LINE_LENGTH, 0)];
    [path addLineToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(0, LINE_LENGTH)];
    
    [path moveToPoint:CGPointMake(LINE_LENGTH, _boxView.frame.size.height)];
    [path addLineToPoint:CGPointMake(0, _boxView.frame.size.height)];
    [path addLineToPoint:CGPointMake(0, _boxView.frame.size.height  - LINE_LENGTH)];
    
    [path moveToPoint:CGPointMake(_boxView.frame.size.width - LINE_LENGTH, 0)];
    [path addLineToPoint:CGPointMake(_boxView.frame.size.width, 0)];
    [path addLineToPoint:CGPointMake(_boxView.frame.size.width, LINE_LENGTH)];
    
    [path moveToPoint:CGPointMake(_boxView.frame.size.width - LINE_LENGTH, _boxView.frame.size.height)];
    [path addLineToPoint:CGPointMake(_boxView.frame.size.width, _boxView.frame.size.height)];
    [path addLineToPoint:CGPointMake(_boxView.frame.size.width, _boxView.frame.size.height - LINE_LENGTH)];
    
    lineLayer.path = path.CGPath;
    lineLayer.strokeColor = LINE_COLOR.CGColor;
    lineLayer.fillColor = [UIColor clearColor].CGColor;
    lineLayer.lineWidth = LINE_WIDTH;
    [_boxView.layer addSublayer:lineLayer];
    
    UIView * maskView = [[UIView alloc] initWithFrame: self.bounds];
    maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:maskView];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:maskView.bounds];
    [maskPath appendPath:[[UIBezierPath bezierPathWithRect:_boxView.frame] bezierPathByReversingPath]];
    maskLayer.path = maskPath.CGPath;
    [maskView.layer setMask:maskLayer];
    
    _scanView = [UIView new];
    _scanView.backgroundColor = LINE_COLOR;
    _scanView.frame = CGRectMake(0, _boxView.frame.size.height/2.0 - 1, _boxView.frame.size.width, 2);
    [_boxView addSubview:_scanView];
    
    [self setRectOfInterest:_boxView.frame];
}

- (void)start {
    [_timer setFireDate:[NSDate date]];
    [_captureSession startRunning];
}

- (void)stop {
    [_timer setFireDate:[NSDate distantFuture]];
    [_captureSession stopRunning];
}

- (void)moveScanView {
    CGRect rect = _scanView.frame;
    rect.origin.y += 10;
    if (rect.origin.y > _boxView.frame.size.height) {
        rect.origin.y = 0;
        _scanView.frame = rect;
        return;
    }
    [UIView animateWithDuration: 0.1 animations:^{
        _scanView.frame = rect;
    }];
}

- (void)setMetadataObjectsDelegate:(id<AVCaptureMetadataOutputObjectsDelegate>)metadataObjectsDelegate queue:(dispatch_queue_t)queue {
    if (!queue) {
        queue = dispatch_queue_create("WZX_QR_QUEUE", NULL);
    }
    [_output setMetadataObjectsDelegate:metadataObjectsDelegate queue:queue];
}

- (void)setRectOfInterest:(CGRect)rectOfInterest {
    _rectOfInterest = rectOfInterest;
    _output.rectOfInterest = CGRectMake(rectOfInterest.origin.y/self.frame.size.height,
                                        rectOfInterest.origin.x/self.frame.size.width,
                                        rectOfInterest.size.height/self.frame.size.height,
                                        rectOfInterest.size.width/self.frame.size.width);
}

@end
