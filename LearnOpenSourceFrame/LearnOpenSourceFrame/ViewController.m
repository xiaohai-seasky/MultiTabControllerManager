//
//  ViewController.m
//  LearnOpenSourceFrame
//
//  Created by apple on 16/8/15.
//  Copyright © 2016年 XiaoHaiSeaSky. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"function - %@", NSStringFromSelector(_cmd));
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"function - %@", NSStringFromSelector(_cmd));
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSLog(@"function - %@", NSStringFromSelector(_cmd));
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    NSLog(@"function - %@", NSStringFromSelector(_cmd));
}

- (void) loadView {
    [super loadView];
    
    NSLog(@"function - %@", NSStringFromSelector(_cmd));
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    NSLog(@"function - %@", NSStringFromSelector(_cmd));
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    NSLog(@"function - %@", NSStringFromSelector(_cmd));
}

- (void) loadViewIfNeeded {
    [super loadViewIfNeeded];
    
    NSLog(@"function - %@", NSStringFromSelector(_cmd));
}

- (void) updateViewConstraints {
    [super updateViewConstraints];
    
    NSLog(@"function - %@", NSStringFromSelector(_cmd));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"function - %@", NSStringFromSelector(_cmd));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
