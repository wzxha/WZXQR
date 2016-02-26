# WZXQRcode

######二维码，封装良好，使用简单(注意只能真机调试)
 <div>
 </div>
######The two-dimensional code, good packaging, simple to use (only device debugging)

 ---
 
<div>
</div>
 基于[QRCodeReader](https://github.com/WuKongCoo1/QRCodeReader) 修改
 <div>
 </div>
 Based on [QRCodeReader](https://github.com/WuKongCoo1/QRCodeReader)
<div>
</div>

##目录(list)
- [效果(Effect)](#效果)
- [怎么使用(How use)](#怎么使用)
- [自定义(Custom)](#自定义)

---

##<a id="效果"></a>效果(Effect)
使用时(In use)
<div>
</div>
![image](https://github.com/Wzxhaha/WZXQRcode/raw/master/use.PNG)
<div>
</div>
扫描结果(Scanning results)
<div>
</div>
![image](https://github.com/Wzxhaha/WZXQRcode/raw/master/read.PNG)
---
##<a id="怎么使用"></a>怎么使用(How use)
- 以`WZXQRViewController`为父类创建一个VC (Create a ViewController what super in `WZXQRViewController`)
- `- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection`方法中找到(Found in this method, the following methods)
```
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

```
- 在`WZXQRJudge.m`中的`judgeQRWithAVMetadataMachineReadableCodeObject:(AVMetadataMachineReadableCodeObject *)metadataObj andSuccess:(SuccessBlock)success andFailure:(FailureBlock)failure`里面做判断(In this method to do judgment)
比如:
```
 //在此做判断,In here to do judgment
    if (metadataObj)
    {
        success();
    }
    else
    {
        failure();
    }
```
- 运行程序，你就获得了一个二维码扫描VC(To run the program, you will get a qr code scanning of ViewController)

---

##<a id="自定义"></a>自定义(Custom)
- 自定义颜色(Custom colors)
在`WZXQRViewController.m`中有三个宏定义`LineColor`四个角的颜色、`LineLength`四个角的长度、`LineWidth`四个角的宽度。
<div>
</div>
In ` WZXQRViewController.m`has three macro definition : ` LineColor ` (The color of the four corners) ` LineLength ` (The length of the four corners)` LineWidth ` (the width of the four corners).
