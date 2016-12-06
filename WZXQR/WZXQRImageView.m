//
//  WZXQRImage.m
//  WZXQRDemo
//
//  Created by WzxJiang on 16/8/4.
//  Copyright © 2016年 wzx. All rights reserved.
//

#import "WZXQRImageView.h"

@implementation WZXQRImageView

- (void)setTitle:(NSString *)title andImage:(UIImage *)image {
    _title = title;
    _avater = image;
    self.image = [self wzx_qrImageWithTitle:title];;
}

- (UIImage *)wzx_qrImageWithTitle:(NSString *)title {
    // 1. 实例化二维码滤镜
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2. 恢复滤镜的默认属性
    
    [filter setDefaults];
    
    // 3. 将字符串转换成
    
    NSData  *data = [title dataUsingEncoding:NSUTF8StringEncoding];
    
    // 4. 通过KVO设置滤镜inputMessage数据
    
    [filter setValue:data forKey:@"inputMessage"];
    // 纠错等级
    [filter setValue:@"Q" forKey:@"inputCorrectionLevel"];
    
    // 5. 获得滤镜输出的图像
    
    CIImage *outputImage = [filter outputImage];
    
    // 6. 将CIImage转换成UIImage，并放大显示
    
    return [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:self.frame.size.width];
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    
    CGRect extent = CGRectIntegral(image.extent);
    
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap;
    
    size_t width = CGRectGetWidth(extent) * scale;
    
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    
    CGContextScaleCTM(bitmapRef, scale, scale);
    
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    CGContextRelease(bitmapRef);
    
    CGImageRelease(bitmapImage);
    
    if (_avater) {
        return [self addIconToQRCodeImage:[UIImage imageWithCGImage:scaledImage] withIcon:_avater withIconSize:CGSizeMake(self.frame.size.width/6.0, self.frame.size.width/6.0)];
    } else {
        return [UIImage imageWithCGImage:scaledImage];
    }
    
}

- (UIImage *)addIconToQRCodeImage:(UIImage *)image withIcon:(UIImage *)icon withIconSize:(CGSize)iconSize {
    UIGraphicsBeginImageContext(image.size);
    //通过两张图片进行位置和大小的绘制，实现两张图片的合并；其实此原理做法也可以用于多张图片的合并
    CGFloat widthOfImage = image.size.width;
    CGFloat heightOfImage = image.size.height;
    CGFloat widthOfIcon = iconSize.width;
    CGFloat heightOfIcon = iconSize.height;

    [image drawInRect:CGRectMake(0, 0, widthOfImage, heightOfImage)];
    [icon drawInRect:CGRectMake((widthOfImage-widthOfIcon)/2, (heightOfImage-heightOfIcon)/2, widthOfIcon, heightOfIcon)];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    return img;
}


@end
