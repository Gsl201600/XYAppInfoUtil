//
//  XyCPUUtil.h
//  XYAppInfoUtil
//
//  Created by Yostar on 2020/3/23.
//  Copyright © 2020 Yostar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XyCPUUtil : NSObject

//获取CPU使用率
+ (CGFloat)cpuUsageForApp;

//获取CPU类型
+ (NSString *)cpuType;

@end

NS_ASSUME_NONNULL_END
