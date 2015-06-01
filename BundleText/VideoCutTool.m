//
//  VideoCutTool.m
//  BundleText
//
//  Created by BIGBO on 15/5/12.
//  Copyright (c) 2015年 BIGBO. All rights reserved.
//

#define VIDEO_SIZE 480.0f

#import "VideoCutTool.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>


@implementation VideoCutTool
+ (void)loadVideoByPath:(NSString *)videoPath andSavePath:(NSString*)savePath{
    
    AVAsset *avAsset = [AVAsset assetWithURL:[NSURL URLWithString:videoPath]];
    CMTime assetTime = [avAsset duration];
    CGFloat duration = CMTimeGetSeconds(assetTime);
    NSLog(@"视频时长 ＝ %f", duration);
    AVMutableComposition *avMutableComposition = [AVMutableComposition composition];
    AVMutableCompositionTrack * avMutableCompositionTrack = [avMutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *avAssetTrack = [[avAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    NSError *error = nil;
    
    [avMutableCompositionTrack insertTimeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(2.0f, 30), CMTimeMakeWithSeconds(5.0f, 30))
                                       ofTrack:avAssetTrack
                                        atTime:kCMTimeZero
                                         error:&error];

    

    //裁剪视屏大小
    AVMutableVideoComposition *avMutableVideoComposition = [AVMutableVideoComposition videoComposition];
    avMutableVideoComposition.renderSize = CGSizeMake(VIDEO_SIZE, VIDEO_SIZE);
    avMutableVideoComposition.frameDuration = CMTimeMake(1, 30);
    
    AVMutableVideoCompositionInstruction *avMutableVideoCompositionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    [avMutableVideoCompositionInstruction setTimeRange:CMTimeRangeMake(kCMTimeZero, [avMutableComposition duration])];
    
    AVMutableVideoCompositionLayerInstruction *avMutableVideoCompositionLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:avAssetTrack];
    [avMutableVideoCompositionLayerInstruction setTransform:avAssetTrack.preferredTransform atTime:kCMTimeZero];
    avMutableVideoCompositionInstruction.layerInstructions = [NSArray arrayWithObject:avMutableVideoCompositionLayerInstruction];
    avMutableVideoComposition.instructions= [NSArray arrayWithObject:avMutableVideoCompositionInstruction];
    
    // 判断保存路劲是否存在
    NSFileManager *fm = [[NSFileManager alloc] init];
//    if ([fm fileExistsAtPath:videoPath]) {
//        NSLog(@"视频已存在， 删掉");
//        if ([fm removeItemAtPath:savePath error:&error]) {
//            NSLog(@"视频已删除");
//        }else {
//           
//            NSLog(@"删除有误 ＝ %@", error.description);
//        }
//    }
    
    // 导出视频
    AVAssetExportSession *avAssetExportSession = [[AVAssetExportSession alloc]initWithAsset:avMutableComposition presetName:AVAssetExportPreset640x480];
    [avAssetExportSession setVideoComposition:avMutableVideoComposition];
    [avAssetExportSession setOutputURL:[NSURL fileURLWithPath:savePath]];
    [avAssetExportSession setOutputFileType:AVFileTypeQuickTimeMovie];
    [avAssetExportSession setShouldOptimizeForNetworkUse:YES];
    [avAssetExportSession exportAsynchronouslyWithCompletionHandler:^{
        
        switch (avAssetExportSession.status) {
            case AVAssetExportSessionStatusFailed:
                NSLog(@"AVAssetExportSessionStatusFailed");
                NSLog(@"exporting failed %@",[avAssetExportSession error]);
                break;
            case AVAssetExportSessionStatusCompleted:
                NSLog(@"AVAssetExportSessionStatusCompleted");
                break;
            case AVAssetExportSessionStatusCancelled:
               NSLog(@"AVAssetExportSessionStatusCancelled");
                break;
            case AVAssetExportSessionStatusWaiting:
                NSLog(@"AVAssetExportSessionStatusWaiting");
                break;
            case AVAssetExportSessionStatusExporting:
                NSLog(@"AVAssetExportSessionStatusExporting");
                break;
            case AVAssetExportSessionStatusUnknown:
                NSLog(@"AVAssetExportSessionStatusUnknown");
                break;
        }
        
        if (avAssetExportSession.status != AVAssetExportSessionStatusCompleted){
            NSLog(@"retry export");
        }

        
    }];

}
@end
