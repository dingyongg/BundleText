//
//  ViewController.m
//  BundleText
//
//  Created by BIGBO on 15/5/9.
//  Copyright (c) 2015年 BIGBO. All rights reserved.
//

#import "ViewController.h"
#import "VideoCutTool.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(100, 100, 100, 40);
    [button setBackgroundColor:[UIColor grayColor]];
    [button setTitle:@"获取摄像头" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
}
- (void)buttonAction{
    UIImagePickerController *IPC = [[UIImagePickerController alloc]init];
    IPC.delegate = self;
    [IPC setSourceType:UIImagePickerControllerSourceTypeCamera];
    IPC.mediaTypes = @[@"public.movie"];
    IPC.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    IPC.allowsEditing = YES;
    IPC.videoQuality = UIImagePickerControllerQualityTypeMedium;
    [self presentViewController:IPC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"%@", info);
    NSString *videoPath = [[info[UIImagePickerControllerMediaURL] absoluteString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [VideoCutTool loadVideoByPath:videoPath andSavePath:@"/Users/redbanana/Desktop/checkout/video.MOV"];
//    NSError *error = nil;
//    
//    AVAsset *asset = [AVAsset assetWithURL:info[UIImagePickerControllerMediaURL]];
//    
//    AVAssetReader *reader = [[AVAssetReader alloc]initWithAsset:asset error:&error];
//    BOOL success = (reader != nil);
//    
//    AVAssetTrack *avAssetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
//    
//    NSDictionary* settings = [NSDictionary dictionaryWithObjectsAndKeys:
//                              AVVideoCodecH264, AVVideoCodecKey,
//                              [NSNumber numberWithInt: 480], AVVideoWidthKey,
//                              [NSNumber numberWithInt: 480], AVVideoHeightKey,
//                              AVVideoScalingModeResizeAspectFill,AVVideoScalingModeKey,
//                              nil];
//    
//    AVAssetWriterInput *writerIn = [AVAssetWriterInput assetWriterInputWithMediaType:[avAssetTrack mediaType] outputSettings:settings];
    
    
}


-(void)cropVideo:(NSURL*)videoToTrimURL{
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:videoToTrimURL options:nil];
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetHighestQuality];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *outputURL = paths[0];
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager createDirectoryAtPath:outputURL withIntermediateDirectories:YES attributes:nil error:nil];
    outputURL = [outputURL stringByAppendingPathComponent:@"output.mp4"];
    // Remove Existing File
    [manager removeItemAtPath:outputURL error:nil];
    
    
    exportSession.outputURL = [NSURL fileURLWithPath:outputURL];
    exportSession.shouldOptimizeForNetworkUse = YES;
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    CMTime start = CMTimeMakeWithSeconds(1.0, 600); // you will modify time range here
    CMTime duration = CMTimeMakeWithSeconds(15.0, 600);
    CMTimeRange range = CMTimeRangeMake(start, duration);
    exportSession.timeRange = range;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     {
         switch (exportSession.status) {
             case AVAssetExportSessionStatusCompleted:
                 //[self writeVideoToPhotoLibrary:[NSURL fileURLWithPath:outputURL]];
                 NSLog(@"Export Complete %d %@", exportSession.status, exportSession.error);
                 break;
             case AVAssetExportSessionStatusFailed:
                 NSLog(@"Failed:%@",exportSession.error);
                 break;
             case AVAssetExportSessionStatusCancelled:
                 NSLog(@"Canceled:%@",exportSession.error);
                 break;
             default:
                 break;
         }
         
         //[exportSession release];
     }];


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
