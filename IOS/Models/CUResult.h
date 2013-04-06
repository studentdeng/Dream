//
//  CUResult.h
//  Dream
//
//  Created by yg curer on 13-4-6.
//  Copyright (c) 2013年 curer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CUResult : NSObject

+ (CUJSONMapper *)getObjectMapping;

@property (nonatomic, strong) NSString *result;
@property (nonatomic, strong) NSString *message;

@end
