//
//  ViewController.m
//  Example
//
//  Created by WzxJiang on 16/12/6.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import "ViewController.h"
#import "WZXQRView.h"

@interface ViewController () <AVCaptureMetadataOutputObjectsDelegate>

@end

@implementation ViewController {
    WZXQRView * _qrView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _qrView = [[WZXQRView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_qrView];
    [_qrView setMetadataObjectsDelegate:self queue:nil];
    [_qrView start];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        //判断回传的数据类型
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            [_qrView stop];
            NSLog(@"%@", [metadataObj stringValue]);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
