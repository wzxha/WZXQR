//
//  WZXQRImage.h
//  WZXQRDemo
//
//  Created by WzxJiang on 16/8/4.
//  Copyright © 2016年 wzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>

@interface WZXQRImageView : UIImageView

@property(nonatomic, copy)NSString * title;
@property(nonatomic, strong)UIImage * avater;
- (void)setTitle:(NSString *)title andImage:(UIImage *)image;
@end
