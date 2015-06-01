//
//  VideoCutTool.h
//  BundleText
//
//  Created by BIGBO on 15/5/12.
//  Copyright (c) 2015年 BIGBO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoCutTool : NSObject

+ (void)loadVideoByPath:(NSString *)videoPath andSavePath:(NSString*)savePath;

@end
