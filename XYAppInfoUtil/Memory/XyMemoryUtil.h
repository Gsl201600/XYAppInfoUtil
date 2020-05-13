//
//  XyMemoryUtil.h
//  XYAppInfoUtil
//
//  Created by Yostar on 2020/3/23.
//  Copyright © 2020 Yostar. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XyMemoryUtil : NSObject

//当前app内存使用量 MB
+ (NSInteger)useMemoryForApp;

//设备总的内存 MB
+ (NSInteger)totalMemoryForDevice;

/**
 Current disk info
 */
+ (NSString *)disk;

@end

NS_ASSUME_NONNULL_END
