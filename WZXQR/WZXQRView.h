//
//  WZXQRView.h
//  Example
//
//  Created by WzxJiang on 16/12/6.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface WZXQRView : UIView 

@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (nonatomic, assign) CGRect rectOfInterest;

@property (nonatomic, copy)   UIColor * lineColor;

- (void)setMetadataObjectsDelegate:(id<AVCaptureMetadataOutputObjectsDelegate>)metadataObjectsDelegate
                             queue:(dispatch_queue_t)queue;

- (void)start;
- (void)stop;

@end
