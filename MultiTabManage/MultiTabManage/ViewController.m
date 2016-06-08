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

@interface ViewController ()<MultiTabManageViewControllerDatasource, MultiTabManageViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MultiTabManageViewController* tabVC = [[MultiTabManageViewController alloc] init];
    TestController1* vc1 = [[TestController1 alloc] init];
    TestController2* vc2 = [[TestController2 alloc] init];
    TestController3* vc3 = [[TestController3 alloc] init];
    tabVC.controllers = @[vc1, vc2, vc3];
    tabVC.headViewHeight = 150;
    tabVC.datasource = self;
    tabVC.delegate = self;
    
    [tabVC showInView:self.view];
    
}

#pragma mark MultiTabManageViewControllerDatasource
-(CGFloat)heightForHeadContentView:(UIViewController *)multiTabView {
    return 100;
}

//-(UIView*)headItemViewForMultiTabView:(UIViewController*)multiTabView atIndex:(NSInteger)index {
//}

-(UIView*)headItemViewForMultiTabView:(UIViewController *)multiTabView withframe:(CGRect)frame atIndex:(NSInteger)index {
    UIView* headView = [[UIView alloc] init];
    [headView setFrame:frame];
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(3, 3, headView.bounds.size.width-6, (headView.bounds.size.height-9)/2)];
    [lab setText:@"label"];
    [lab setBackgroundColor:[UIColor grayColor]];
    [headView addSubview:lab];
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(3, CGRectGetMaxY(lab.frame)+3, lab.bounds.size.width, lab.bounds.size.height)];
    [btn setTitle:@"button" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor purpleColor]];
    [headView addSubview:btn];
    return headView;
}

-(NSInteger)numberOfHeadItemsInMultiTabView:(UIViewController*)multiTabView {
    return 5;
}

-(UIViewController*)viewControllerForMultiTabView:(UIViewController*)multiTabView atIndex:(NSInteger)index {
    if (index == 0) {
        UIViewController* vc = [[UIViewController alloc] init];
        [vc.view setBackgroundColor:[UIColor redColor]];
        return vc;
    }
    else if (index == 1) {
        UIViewController* vc = [[UIViewController alloc] init];
        [vc.view setBackgroundColor:[UIColor yellowColor]];
        return vc;
    }
    else if (index == 2) {
        UIViewController* vc = [[UIViewController alloc] init];
        [vc.view setBackgroundColor:[UIColor blueColor]];
        return vc;
    }
    else if (index == 3) {
        UIViewController* vc = [[UIViewController alloc] init];
        [vc.view setBackgroundColor:[UIColor greenColor]];
        return vc;
    }
    else {
        UIViewController* vc = [[UIViewController alloc] init];
        [vc.view setBackgroundColor:[UIColor cyanColor]];
        return vc;
    }
}

#pragma mark MultiTabManageViewControllerDelegate
-(void)multiTabView:(UIViewController*)multiTabView didSelectedAtIndex:(NSInteger)index {
    NSLog(@"click at index %d", index);
}

#pragma mark No Use
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
