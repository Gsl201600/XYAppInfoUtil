//
//  XyFPSUtil.m
//  XYAppInfoUtil
//
//  Created by Yostar on 2020/3/23.
//  Copyright © 2020 Yostar. All rights reserved.
//

#import "XyFPSUtil.h"
#import <UIKit/UIKit.h>

@interface XyFPSUtil ()

@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, assign) NSTimeInterval lastTime;
@property (nonatomic, assign) BOOL isStart;
@property (nonatomic, assign) NSInteger fps;
@property (nonatomic, copy) XyFPSBlock block;

@end

@implementation XyFPSUtil

- (instancetype)init{
    self = [super init];
    if (self) {
        _isStart = NO;
        _count = 0;
        _lastTime = 0;
    }
    return self;
}

- (void)start{
    if (_link) {
        _link.paused = NO;
    }else{
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(trigger:)];
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)end{
    if (_link) {
        _link.paused = YES;
        [_link invalidate];
        _link = nil;
        _lastTime = 0;
        _count = 0;
    }
}

- (void)trigger:(CADisplayLink *)link{
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    
    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = link.timestamp;
    CGFloat fps = _count/delta;
    _count = 0;
    
    NSInteger intFps = (NSInteger)(fps + 0.5);
    self.fps = intFps;
    if (self.block) {
        self.block(self.fps);
    }
}

- (void)addFPSBlock:(XyFPSBlock)block{
    self.block = block;
}

@end
