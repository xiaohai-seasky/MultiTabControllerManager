//
//  MultiTabManageViewController.h
//  MultiTabManage
//
//  Created by apple on 16/6/7.
//  Copyright © 2016年 XiaoHaiSeaSky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MultiTabManageViewControllerDatasource <NSObject>
@optional
-(CGFloat)heightForHeadContentView:(UIViewController*)multiTabView;
//-(UIView*)headItemViewForMultiTabView:(UIViewController*)multiTabView atIndex:(NSInteger)index;
-(UIView*)headItemViewForMultiTabView:(UIViewController*)multiTabView withframe:(CGRect)frame atIndex:(NSInteger)index;
-(NSInteger)numberOfHeadItemsInMultiTabView:(UIViewController*)multiTabView;
-(UIViewController*)viewControllerForMultiTabView:(UIViewController*)multiTabView atIndex:(NSInteger)index;
@end

@protocol MultiTabManageViewControllerDelegate <NSObject>
@optional
-(void)multiTabView:(UIViewController*)multiTabView didSelectedAtIndex:(NSInteger)index;
@end




@interface MultiTabManageViewController : UIViewController

@property(weak, nonatomic) id<MultiTabManageViewControllerDatasource> datasource;
@property(weak, nonatomic) id<MultiTabManageViewControllerDelegate> delegate;
@property(strong, nonatomic) NSMutableArray* controllers;
@property(assign, nonatomic) CGFloat headViewHeight;
@property(assign, nonatomic) NSInteger itemsCount;

-(void)showInView:(UIView*)view ;

@end
