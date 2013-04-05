//
//  API.h
//  Dream
//
//  Created by yg curer on 13-3-30.
//  Copyright (c) 2013年 curer. All rights reserved.
//

#define MAIN_PATH       @"http://192.168.1.200/curer/index.php/api"
#define EVALUATE_PLAN   @"/progress/evaluate"
#define UPLOAD_FILE     @"/file/upload"

@class CUObjectManager;
@interface API : NSObject

+ (NSString *)apiPath:(NSString *)path;
+ (CUObjectManager *)shareObjectManager;

@end