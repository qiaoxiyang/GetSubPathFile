//
//  main.m
//  GetImage
//
//  Created by xiyang on 2017/6/27.
//  Copyright © 2017年 xiyang. All rights reserved.
//

#import <Foundation/Foundation.h>
NSMutableArray* getImage(NSArray *array);
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSString *fileStr = [NSString stringWithFormat:@"%@/Desktop/ZiChanXunCha/ZiChanXunCha/Assets.xcassets/KeHuDaiKuan",NSHomeDirectory()];
        
        NSArray *subPath = [fileManager subpathsAtPath:fileStr];
        
        NSMutableArray *imgArr = getImage(subPath);
        NSLog(@"%@",imgArr);
        
        NSString *nFileStr = [NSString stringWithFormat:@"%@/Desktop/NEWFile",NSHomeDirectory()];
        
        for (NSString *file in imgArr) {
            NSString *endFileStr = [fileStr stringByAppendingPathComponent:file];
            NSString *toFileStr = [nFileStr stringByAppendingPathComponent:[file lastPathComponent]];
            [fileManager copyItemAtPath:endFileStr toPath:toFileStr error:nil];
        }
        
    }
    return 0;
}


NSMutableArray* getImage(NSArray *array){
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *imgArr = [NSMutableArray array];
    
    for (NSString *path in array) {
        if ([path hasSuffix:@".png"]) {
            [imgArr addObject:path];
        }else{
            NSArray *pathArr = [fileManager subpathsAtPath:path];
            if (pathArr.count>0) {
                [imgArr addObjectsFromArray:getImage(pathArr)];
            }
            
        }
    }
    return imgArr;
}
