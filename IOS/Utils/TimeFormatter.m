//
//  TimeFormatter.m
//  CUWeiboKit
//
//  Created by yg curer on 13-2-20.
//  Copyright (c) 2013年 curer. All rights reserved.
//

#import "TimeFormatter.h"

@implementation TimeFormatter

static NSDateFormatter *s_format = nil;

+ (NSString *)formatTime:(NSDate *)date
{
    if (s_format == nil) {
        s_format = [[NSDateFormatter alloc] init];
    }
    
    [s_format setDateFormat:@"MM月dd日 HH:mm"];
    
    return [s_format stringFromDate:date];
}

+ (double)timeDiffInSec:(NSDate *)begin andEnd:(NSDate *)end
{
    NSTimeInterval beforeDate = [begin timeIntervalSince1970];
    NSTimeInterval endDate = [end timeIntervalSince1970];
    
    NSTimeInterval subDate = endDate - beforeDate;
    
    return subDate;
}

@end
