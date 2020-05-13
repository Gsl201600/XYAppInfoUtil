//
//  XyCrashUncaughtExceptionHandler.m
//  XYAppInfoUtil
//
//  Created by Yostar on 2020/3/23.
//  Copyright © 2020 Yostar. All rights reserved.
//

#import "XyCrashUncaughtExceptionHandler.h"

// 记录之前的崩溃回调函数
static NSUncaughtExceptionHandler *previousUncaughtExceptionHandler = NULL;

@implementation XyCrashUncaughtExceptionHandler

#pragma mark - Register
+ (void)registerHandler{
    // Backup original handler
    previousUncaughtExceptionHandler = NSGetUncaughtExceptionHandler();
    
    NSSetUncaughtExceptionHandler(&XyUncaughtExceptionHandler);
}

#pragma mark - Private
// 崩溃时的回调函数
static void XyUncaughtExceptionHandler(NSException *exception){
    // 异常的堆栈信息
    NSArray *stackArr = [exception callStackSymbols];
    // 出现异常的原因
    NSString *reasonStr = [exception reason];
    // 异常名称
    NSString *nameStr = [exception name];
    
    NSString *exceptionInfoStr = [NSString stringWithFormat:@"========uncaughtException异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@", nameStr, reasonStr, [stackArr componentsJoinedByString:@"\n"]];
    // 保存崩溃日志到沙盒cache目录
    
    // 调用之前崩溃的回调函数
    if (previousUncaughtExceptionHandler) {
        previousUncaughtExceptionHandler(exception);
    }
    
    // 杀掉程序，这样可以防止同时抛出的SIGABRT被SignalException捕获
    kill(getpid(), SIGKILL);
}

@end
