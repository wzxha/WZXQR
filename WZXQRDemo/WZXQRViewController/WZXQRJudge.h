//
//  WZXQRJudge.h
//  WZXQRDemo
//
//  Created by wordoor－z on 16/2/26.
//  Copyright © 2016年 wzx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface WZXQRJudge : NSObject

typedef void (^SuccessBlock)();
typedef void (^FailureBlock)();

/**
 *  单例
 */
+ (WZXQRJudge *)Judge;


- (void)judgeQRWithAVMetadataMachineReadableCodeObject:(AVMetadataMachineReadableCodeObject *)metadataObj
                andSuccess:(SuccessBlock)success
                andFailure:(FailureBlock)failure;

@end
