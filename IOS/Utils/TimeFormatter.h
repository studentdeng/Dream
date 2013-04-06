//
//  TimeFormatter.h
//  CUWeiboKit
//
//  Created by yg curer on 13-2-20.
//  Copyright (c) 2013年 curer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeFormatter : NSObject

+ (NSString *)formatTime:(NSDate *)date;
+ (double) timeDiffInSec:(NSDate *)begin andEnd:(NSDate *)end;

@end
