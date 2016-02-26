//
//  WZXQRViewController.m
//  WZXQRDemo
//
//  Created by wordoor－z on 16/2/26.
//  Copyright © 2016年 wzx. All rights reserved.
//

#import "WZXQRViewController.h"
#import "WZXQRJudge.h"

#define LineColor [UIColor redColor]
#define LineLength 16
#define LineWidth 2

@interface WZXQRViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property(nonatomic,strong)UIView * backGroundView;
@property (strong, nonatomic) UIView *boxView;
//捕捉会话
@property (nonatomic, strong) AVCaptureSession *captureSession;
//展示layer
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@end

@implementation WZXQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _captureSession = nil;
    
    _backGroundView = ({
        UIView * backGroundView = [[UIView alloc]initWithFrame:self.view.bounds];
        backGroundView.backgroundColor = [UIColor blackColor];
        backGroundView;
    });
    [self.view addSubview:_backGroundView];
    
    [self startReading];
}
- (void)startReading {
    NSError *error;
    //1.初始化捕捉设备（AVCaptureDevice），类型为AVMediaTypeVideo
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //2.用captureDevice创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    //没打开就中断
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return;
    }
    
    //3.创建媒体数据输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    //4.实例化捕捉会话
    _captureSession = [[AVCaptureSession alloc] init];
    //4.1.将输入流添加到会话
    [_captureSession addInput:input];
    //4.2.将媒体输出流添加到会话中
    [_captureSession addOutput:captureMetadataOutput];
    //5.创建串行队列，并加媒体输出流添加到队列当中
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    //5.1.设置代理
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    //5.2.设置输出媒体数据类型为QRCode
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    //6.实例化预览图层
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    //7.设置预览图层填充方式
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    //8.设置图层的frame
    [_videoPreviewLayer setFrame:_backGroundView.frame];
    //9.将图层添加到预览view的图层上
    [_backGroundView.layer addSublayer:_videoPreviewLayer];
    //10.设置扫描范围
    captureMetadataOutput.rectOfInterest = CGRectMake(0.2f, 0.2f, 0.8f, 0.8f);
    //10.1.扫描框
     CGFloat width = _backGroundView.frame.size.width * 0.75;
    _boxView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - width)/2.0, (self.view.frame.size.height - width)/2.0 - 64, width, width)];
    [_backGroundView addSubview:_boxView];
  
    //10.1.1 四角
    for (int i = 0; i< 8; i++)
    {
        UIView * lineView = [[UIView alloc]init];
        lineView.backgroundColor = [UIColor redColor];
        switch (i)
        {
            case 0:
            {
                lineView.frame = CGRectMake(0, 0, LineLength, LineWidth);
            }
                break;
            case 1:
            {
                lineView.frame = CGRectMake(0, 0, LineWidth, LineLength);
            }
                break;
            case 2:
            {
                lineView.frame = CGRectMake(_boxView.frame.size.width - LineLength, 0, LineLength, LineWidth);
            }
                break;
            case 3:
            {
                lineView.frame = CGRectMake(_boxView.frame.size.width - LineWidth, 0, LineWidth, LineLength);
            }
                break;
            case 4:
            {
                lineView.frame = CGRectMake(0, _boxView.frame.size.height - LineLength, LineWidth, LineLength);
            }
                break;
            case 5:
            {
                lineView.frame = CGRectMake(0, _boxView.frame.size.height - LineWidth, LineLength, LineWidth);
            }
                break;
            case 6:
            {
                lineView.frame = CGRectMake( _boxView.frame.size.width - LineLength,_boxView.frame.size.height - LineWidth, LineLength, LineWidth);
            }
                break;
            case 7:
            {
                lineView.frame = CGRectMake(_boxView.frame.size.width - LineWidth, _boxView.frame.size.height - LineLength, LineWidth, LineLength);
            }
                break;

            default:
                break;
        }
        
        [_boxView addSubview:lineView];
    }
    
    
    //10.2 加maskView
    UIView * maskView = [[UIView alloc]initWithFrame:_backGroundView.frame];
    maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self.view addSubview:maskView];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:maskView.bounds];
    
    [path appendPath:[[UIBezierPath bezierPathWithRect:_boxView.frame] bezierPathByReversingPath]];
    
    maskLayer.path = path.CGPath;
    
    [maskView.layer setMask:maskLayer];
    
    
    
    //11.开始扫描
    [_captureSession startRunning];
}

- (void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    [_videoPreviewLayer removeFromSuperlayer];
}

- (void)start
{
    [_captureSession startRunning];
}

- (void)stop
{
    [_captureSession stopRunning];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //判断是否有数据
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        //判断回传的数据类型
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
             [_captureSession stopRunning];
            
            [[WZXQRJudge Judge]judgeQRWithAVMetadataMachineReadableCodeObject:metadataObj andSuccess:^{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:nil message:[metadataObj stringValue] preferredStyle:UIAlertControllerStyleAlert];
                    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [_captureSession startRunning];
                    }]];
                    [self presentViewController:alertVC animated:YES completion:^{
                    }];
                });
                
            } andFailure:^{
               
                NSLog(@"失败");
                 [_captureSession startRunning];
                
            }];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
