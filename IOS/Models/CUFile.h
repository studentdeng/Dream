//
//  CUFile.h
//  Dream
//
//  Created by yg curer on 13-4-5.
//  Copyright (c) 2013年 curer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CUFile : NSObject

+ (CUJSONMapper *)getObjectMapping;

@property (nonatomic, strong) NSString *url;

@end
