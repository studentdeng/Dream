//
//  CUResult.m
//  Dream
//
//  Created by yg curer on 13-4-6.
//  Copyright (c) 2013年 curer. All rights reserved.
//

#import "CUResult.h"

@implementation CUResult

+ (CUJSONMapper *)getObjectMapping
{
    CUJSONMapper *adMapper = [[CUJSONMapper alloc] init];
    [adMapper registerClass:[CUResult class] andMappingDescription:@{
     @"result": @"result",
     @"message": @"message"
     }];
    
    return adMapper;
}

@end
