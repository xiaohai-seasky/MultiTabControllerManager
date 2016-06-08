//
//  ViewController.m
//  MultiTabManage
//
//  Created by apple on 16/6/7.
//  Copyright © 2016年 XiaoHaiSeaSky. All rights reserved.
//

#import "ViewController.h"
#import "MultiTabManageViewController.h"
#import "TestController1.h"
#import "TestController2.h"
#import "TestController3.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MultiTabManageViewController* tabVC = [[MultiTabManageViewController alloc] init];
    TestController1* vc1 = [[TestController1 alloc] init];
    TestController2* vc2 = [[TestController2 alloc] init];
    TestController3* vc3 = [[TestController3 alloc] init];
    tabVC.controllers = @[vc1, vc2, vc3];
    
    [tabVC showInView:self.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
