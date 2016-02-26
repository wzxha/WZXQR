//
//  WZXQRJudge.m
//  WZXQRDemo
//
//  Created by wordoor－z on 16/2/26.
//  Copyright © 2016年 wzx. All rights reserved.
//

#import "WZXQRJudge.h"

@implementation WZXQRJudge

+ (WZXQRJudge *)Judge
{
    static WZXQRJudge * judge = nil;
    if (judge == nil)
    {
        judge = [[WZXQRJudge alloc]init];
    }
    return judge;
}

- (void)judgeQRWithAVMetadataMachineReadableCodeObject:(AVMetadataMachineReadableCodeObject *)metadataObj andSuccess:(SuccessBlock)success andFailure:(FailureBlock)failure
{
    //在此做判断
    if (metadataObj)
    {
        success();
    }
    else
    {
        failure();
    }
}

@end
