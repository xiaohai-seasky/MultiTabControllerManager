//
//  MultiTabManageViewController.m
//  MultiTabManage
//
//  Created by apple on 16/6/7.
//  Copyright © 2016年 XiaoHaiSeaSky. All rights reserved.
//

#import "MultiTabManageViewController.h"

@interface MultiTabManageViewController ()

@property(strong, nonatomic) UIView* superContentView;
@property(strong, nonatomic) UIView* headContentView;
@property(strong, nonatomic) UIView* bodyContentView;
//@property(strong, nonatomic) NSMutableArray* controllers;
@property(strong, nonatomic) NSMutableArray* innerItemViews;
// 默认数据
@property(assign, nonatomic) NSInteger itemsCount;
@property(assign, nonatomic) NSInteger currSelectedIndex;
@property(strong, nonatomic) UIViewController* currVC;
@property(assign, nonatomic) NSInteger configItemTAg;
@property(strong, nonatomic) UIViewController* currDisplayController;
@property(assign, nonatomic) BOOL isUseDatasurceVC;

@end

@implementation MultiTabManageViewController

#pragma mark 系统生命周期函数
- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark 重写
-(instancetype)init {
    self = [super init];
    
    [self setUpData];
    //[self setUpUI];
    return self;
}

//-(void)setControllers:(NSMutableArray *)controllers {
//    self.controllers = controllers;
//    [self startShow]; /////////////
//}

#pragma mark 自定义韩式
-(void)showInView:(UIView*)view {
    self.superContentView = view;
    [view addSubview:self.view];
    [self.view setFrame:view.bounds];
    [self setUpUI];
    
    //[self.view layoutSubviews];
}

-(void)setUpData {
    self.controllers = [[NSMutableArray alloc] init];
    self.innerItemViews = [[NSMutableArray alloc] init];
    
    self.itemsCount = 3;
    self.currSelectedIndex = 0;
    self.configItemTAg = 1000;
    self.isUseDatasurceVC = true;
}

-(void)setUpUI {
    
    self.headContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
    [self.view addSubview:self.headContentView];
    [self.headContentView setBackgroundColor:[UIColor blueColor]];
    
    CGFloat bodyContentViewY = self.headContentView.frame.origin.x+self.headContentView.bounds.size.height;
    CGFloat bodyContentViewH = self.view.bounds.size.height-bodyContentViewY;
    self.bodyContentView = [[UIView alloc] initWithFrame:CGRectMake(0, bodyContentViewY, self.view.bounds.size.width, bodyContentViewH)];
    [self.view addSubview:self.bodyContentView];
    [self.bodyContentView setBackgroundColor:[UIColor brownColor]];
    
    if (self.datasource != nil && [self.datasource respondsToSelector:@selector(numberOfHeadItemsInMultiTabView:)]) {
        self.itemsCount = [self.datasource numberOfHeadItemsInMultiTabView:self]; // 可变
    }
    
    CGFloat itemX = 0;
    CGFloat itemY = 0;
    CGFloat itemW = self.headContentView.bounds.size.width/self.itemsCount;
    CGFloat itemH = self.headContentView.bounds.size.height;
    for (int i = 0; i < self.itemsCount; i++) {
        UIView* innerItem = [[UIView alloc] init]; // 可变
        if (self.datasource != nil && [self.datasource respondsToSelector:@selector(headItemViewForMultiTabView:atIndex:)]) {
            innerItem = [self.datasource headItemViewForMultiTabView:self atIndex:i];
        }
        [innerItem setFrame:CGRectMake(i*itemW+itemX, itemY, itemW, itemH)];
        [innerItem layoutSubviews];
        [innerItem setBackgroundColor:[UIColor cyanColor]];
        [innerItem setTag:self.configItemTAg+i];
        [self.headContentView addSubview:innerItem];
        self.innerItemViews = self.headContentView.subviews;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapItemAtIndex:)];
        [innerItem addGestureRecognizer:tap];
        
        if (self.isUseDatasurceVC) {  // 可变
            if (self.datasource != nil && [self.datasource respondsToSelector:@selector(viewControllerForMultiTabView:atIndex:)]) {
                [self.controllers addObject:[self.datasource viewControllerForMultiTabView:self atIndex:i]];
            }
        }
        
        if (self.controllers.count > 0) {
            [self startShow];
        }
    }
}

// 相应标签被点击的响应函数
-(void)tapItemAtIndex:(UITapGestureRecognizer*)gesture {
    NSInteger index = gesture.view.tag - self.configItemTAg;
    self.currSelectedIndex = index;
    NSLog(@"item index is %d", index);
    
    // 内部动作逻辑
    [self changeSubVCShowWithIndex:index];
    
    // 代理动作逻辑
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(multiTabView:didSelectedAtIndex:)]) {
        [self.delegate multiTabView:self didSelectedAtIndex:index];
    }
}

// 选择相应标签的动作函数
-(void)changeSubVCShowWithIndex:(NSInteger)index {
    for (UIView* view in self.innerItemViews) {
        [view setBackgroundColor:[UIColor cyanColor]];
    }
    UIView* selView = [self.innerItemViews objectAtIndex:index];
    [selView setBackgroundColor:[UIColor redColor]];
    
    [self.currDisplayController willMoveToParentViewController:nil];
    [self.currDisplayController.view removeFromSuperview];
    [self.currDisplayController removeFromParentViewController];
    [self.currDisplayController didMoveToParentViewController:nil];
    UIViewController* willShowView = [self.controllers objectAtIndex:index];
    [willShowView willMoveToParentViewController:self];
    [self.bodyContentView insertSubview:willShowView.view atIndex:0];
    [self addChildViewController:willShowView];
    [willShowView didMoveToParentViewController:self];
    
    self.currDisplayController = willShowView;
    
    // 切换子视图控制器后重新布局
    //repositionViewForVC[(willShowView)
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

// 初始显示配置
-(void)startShow {
    if (self.controllers.count <= 0) {
        NSLog(@"必须给 MultiTabManangeController 的 controllers 属性赋值，或实现 MultiTabManangeControllerDataSource 的代理方法 viewController(multiTabView: forIndex:) -> UIViewController 提供所需要展示的视图控制器");
        return;
    }
    
    UIView* view = [self.innerItemViews objectAtIndex:0];
    [view setBackgroundColor:[UIColor redColor]];
    UIViewController* willShowVC = [self.controllers objectAtIndex:self.currSelectedIndex];
    [willShowVC willMoveToParentViewController:self];
    [self.bodyContentView insertSubview:willShowVC.view atIndex:0];
    [self addChildViewController:willShowVC];
    [willShowVC didMoveToParentViewController:self];
    
    self.currDisplayController = willShowVC;
    
    // 重新布局子视图的view
    [self repositionViewForVC:willShowVC];
}

// 重新布局子视图的view方法
-(void)repositionViewForVC:(UIViewController*)vc {
    NSLog(@"This method is not implemente yet");
}


#pragma mark No Use
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
