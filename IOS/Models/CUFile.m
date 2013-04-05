//
//  CUFile.m
//  Dream
//
//  Created by yg curer on 13-4-5.
//  Copyright (c) 2013年 curer. All rights reserved.
//

#import "CUFile.h"

@implementation CUFile

+ (CUJSONMapper *)getObjectMapping
{
    CUJSONMapper *adMapper = [[CUJSONMapper alloc] init];
    [adMapper registerClass:[CUFile class] andMappingDescription:@{
     @"url": @"url"
     }];
    
    return adMapper;
}

@end
