//
//  ViewController.m
//  Camera
//
//  Created by apple on 14-5-8.
//  Copyright (c) 2014年 Woddon. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)comeInToCamera:(id)sender {
    
//    在这里进行检测设备是否支持前后摄像头
    
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
        m_tempMiddle = [[tempMiddle alloc]init];
        [self.view addSubview:m_tempMiddle];
    }
   
    
}
@end
















