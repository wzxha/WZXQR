# WZXQRcode

```objc
    WZXQRView * qrView = [[WZXQRView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_qrView];
    [_qrView setMetadataObjectsDelegate:self queue:nil];
    [_qrView start];
```
