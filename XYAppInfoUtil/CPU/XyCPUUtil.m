//
//  XyCPUUtil.m
//  XYAppInfoUtil
//
//  Created by Yostar on 2020/3/23.
//  Copyright © 2020 Yostar. All rights reserved.
//

#import "XyCPUUtil.h"
#import <mach/mach.h>
#import <UIKit/UIKit.h>

#import <mach-o/arch.h>

@implementation XyCPUUtil

+ (CGFloat)cpuUsageForApp{
    kern_return_t kr;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    thread_basic_info_t basic_info_th;
    
    // get threads in the task
    //  获取当前进程中 线程列表
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS)
        return -1;

    float tot_cpu = 0;
    
    for (int j = 0; j < thread_count; j++) {
        thread_info_count = THREAD_INFO_MAX;
        //获取每一个线程信息
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS)
            return -1;
        
        basic_info_th = (thread_basic_info_t)thinfo;
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            // cpu_usage : Scaled cpu usage percentage. The scale factor is TH_USAGE_SCALE.
            //宏定义TH_USAGE_SCALE返回CPU处理总频率：
            tot_cpu += basic_info_th->cpu_usage / (float)TH_USAGE_SCALE;
        }
        
    } // for each thread
    
    // 注意方法最后要调用 vm_deallocate，防止出现内存泄漏
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    if (tot_cpu < 0) {
        tot_cpu = 0.;
    }
    
    return tot_cpu;
}

/**
// Credit to: http://stackoverflow.com/questions/8223348/ios-get-cpu-usage-from-application
+ (CGFloat)cpuUsageForApp {
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    //获取当前任务，即当前的进程信息
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS)
        return -1;
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    //  获取当前进程中 线程列表
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS)
        return -1;
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++) {
        thread_info_count = THREAD_INFO_MAX;
        //获取每一个线程信息
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS)
            return -1;
        
        basic_info_th = (thread_basic_info_t)thinfo;
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            // cpu_usage : Scaled cpu usage percentage. The scale factor is TH_USAGE_SCALE.
            //宏定义TH_USAGE_SCALE返回CPU处理总频率：
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE;
        }
        
    } // for each thread
    
    // 注意方法最后要调用 vm_deallocate，防止出现内存泄漏
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return tot_cpu;
}
 
 */

+ (NSString *)cpuType{
    return [self cpuSubtypeString] ?: @"Unknown";
}

+ (NSString *)cpuTypeString {
    NSString *cpuTypeString = [self stringFromCpuType:[self getCpuType]];
    return cpuTypeString;
}

+ (NSString *)cpuSubtypeString {
    NSString *cpuSubtypeString = [NSString stringWithUTF8String:NXGetLocalArchInfo()->description];
    return cpuSubtypeString;
}

+ (NSInteger)getCpuType {
    return (NSInteger)(NXGetLocalArchInfo()->cputype);
}

+ (NSInteger)getCpuSubtype {
    return (NSInteger)(NXGetLocalArchInfo()->cpusubtype);
}

+ (NSString *)stringFromCpuType:(NSInteger)cpuType {
    switch (cpuType) {
        case CPU_TYPE_VAX:          return @"VAX";
        case CPU_TYPE_MC680x0:      return @"MC680x0";
        case CPU_TYPE_X86:          return @"X86";
        case CPU_TYPE_X86_64:       return @"X86_64";
        case CPU_TYPE_MC98000:      return @"MC98000";
        case CPU_TYPE_HPPA:         return @"HPPA";
        case CPU_TYPE_ARM:          return @"ARM";
        case CPU_TYPE_ARM64:        return @"ARM64";
        case CPU_TYPE_MC88000:      return @"MC88000";
        case CPU_TYPE_SPARC:        return @"SPARC";
        case CPU_TYPE_I860:         return @"I860";
        case CPU_TYPE_POWERPC:      return @"POWERPC";
        case CPU_TYPE_POWERPC64:    return @"POWERPC64";
        default:                    return @"Unknown";
    }
}

@end
