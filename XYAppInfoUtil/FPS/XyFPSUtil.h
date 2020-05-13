//
//  XyFPSUtil.h
//  XYAppInfoUtil
//
//  Created by Yostar on 2020/3/23.
//  Copyright © 2020 Yostar. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^XyFPSBlock)(NSInteger fps);

@interface XyFPSUtil : NSObject

- (void)start;
- (void)end;
- (void)addFPSBlock:(XyFPSBlock)block;

@end

NS_ASSUME_NONNULL_END
