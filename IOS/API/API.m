//
//  API.m
//  Dream
//
//  Created by yg curer on 13-3-30.
//  Copyright (c) 2013年 curer. All rights reserved.
//

#import "API.h"
#import "CUFile.h"
#import "CUResult.h"

@implementation API

+ (NSString *)apiPath:(NSString *)path
{
    return [NSString stringWithFormat:@"%@%@", MAIN_PATH, path];
}

+ (CUObjectManager *)shareObjectManager
{
    static CUObjectManager *s_shareInstancce = nil;
    
    if (s_shareInstancce == nil) {
        s_shareInstancce = [[CUObjectManager alloc] init];
        s_shareInstancce.baseURLString = MAIN_PATH;
        [API setupObjectMapping:s_shareInstancce];
    }
    
    return s_shareInstancce;
}

+ (void)setupObjectMapping:(CUObjectManager *)manager
{
    [manager registerMapper:[CUFile getObjectMapping]
               atServerPath:UPLOAD_FILE
                andJSONPath:@""];
    
    [manager registerMapper:[CUResult getObjectMapping]
               atServerPath:ADD_PROGRESS
                andJSONPath:@""];
}

@end
