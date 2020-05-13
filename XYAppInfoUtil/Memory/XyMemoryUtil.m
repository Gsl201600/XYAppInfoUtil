//
//  XyMemoryUtil.m
//  XYAppInfoUtil
//
//  Created by Yostar on 2020/3/23.
//  Copyright © 2020 Yostar. All rights reserved.
//

#import "XyMemoryUtil.h"
#import <mach/mach.h>

@implementation XyMemoryUtil

+ (NSInteger)useMemoryForApp{
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kernelReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    if(kernelReturn == KERN_SUCCESS){
        int64_t memoryUsageInByte = (int64_t) vmInfo.phys_footprint;
        return (NSInteger)(memoryUsageInByte/1024/1024);
    }else{
        return -1;
    }
}

//设备总的内存
+ (NSInteger)totalMemoryForDevice{
    return (NSInteger)([NSProcessInfo processInfo].physicalMemory/1024/1024);
}

+ (NSString *)disk{
    NSString *free = [NSByteCountFormatter stringFromByteCount:[self getFreeDisk] countStyle:NSByteCountFormatterCountStyleFile];
    NSString *total = [NSByteCountFormatter stringFromByteCount:[self getTotalDisk] countStyle:NSByteCountFormatterCountStyleFile];
    return [NSString stringWithFormat:@"free:%@ / total:%@", free,total];
}

#pragma mark - Disk
+ (unsigned long long)getTotalDisk {
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [[fattributes objectForKey:NSFileSystemSize] unsignedLongLongValue];
}

+ (unsigned long long)getFreeDisk {
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [[fattributes objectForKey:NSFileSystemFreeSize] unsignedLongLongValue];
}

@end
