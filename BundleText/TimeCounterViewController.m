//
//  TimeCounterViewController.m
//  BundleText
//
//  Created by BIGBO on 15/5/14.
//  Copyright (c) 2015年 BIGBO. All rights reserved.
//

#import "TimeCounterViewController.h"

@interface TimeCounterViewController ()
@property (assign, nonatomic) int time;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) UILabel *timeCountLabel;

@end

@implementation TimeCounterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.time = 0;
    self.timeCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 100, 50)];
    self.timeCountLabel.text = [NSString stringWithFormat:@"%.2d:%.2d", self.time/60, self.time%60];
    [self.timeCountLabel setBackgroundColor:[UIColor grayColor]];
    
    self.timeCountLabel.font = [UIFont systemFontOfSize:20];
    
    [self.view addSubview:self.timeCountLabel];
    
    UIButton *startCountButton = [[UIButton alloc]initWithFrame:CGRectMake(50, 200, 80, 50)];
    [startCountButton setTitle:@"开始" forState:UIControlStateNormal];
    [startCountButton addTarget:self action:@selector(startCount) forControlEvents:UIControlEventTouchUpInside];
    startCountButton.backgroundColor = [UIColor grayColor];
    [self.view addSubview:startCountButton];
    
    
    UIButton *stopCountButton = [[UIButton alloc]initWithFrame:CGRectMake(200, 200, 80, 50)];
    [stopCountButton setTitle:@"停止" forState:UIControlStateNormal];
    [stopCountButton addTarget:self action:@selector(stopCount) forControlEvents:UIControlEventTouchUpInside];
    stopCountButton.backgroundColor = [UIColor grayColor];
    [self.view addSubview:stopCountButton];
    
}

- (void)startCount{
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(counting) userInfo:nil repeats:YES];

}

- (void)counting{
    self.time++;
    self.timeCountLabel.text = [NSString stringWithFormat:@"%.2d:%.2d", self.time/60, self.time%60];

}

- (void)stopCount{
    
    [self.timer invalidate];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
