//
//  MultiTabManageViewController.m
//  MultiTabManage
//
//  Created by apple on 16/6/7.
//  Copyright © 2016年 XiaoHaiSeaSky. All rights reserved.
//
//
/** 
    controllers 为需要切换展示的视图对应的视图控制器，数组内容可以通过属性 .controllers 设置，也可以通过实现 MultiTabManageViewControllerDatasource 的代理方法 viewControllerForMultiTabView: atIndex: 来提供。   ＊注意＊如果同时使用这两种方法设置 controllers 数组内容，则以代理方法为准，但是必须至少使用一种方法来提供 controllers 的值。
 
    headViewHeight 为头部标签按钮的承载视图的高度，可以通过 .headViewHeight 属性设置，也可以通过实现 MultiTabManageViewControllerDatasource 的代理方法 heightForHeadContentView: 来提供。   ＊注意＊如果同时使用这两种方法设置 headViewHeight 的值，则以代理方法为准，如果不进行设置，默认为 50。
 
    itemsCount 为需要切换的视图控制器的个数，可以通过 .itemsCount 属性设置，也可以通过实现 MultiTabManageViewControllerDatasource 的代理方法 numberOfHeadItemsInMultiTabView: 来提供。   ＊注意＊如果需要切换的视图控制器只有3个该字段可以不设置，否则必须设置，而且代理的设置数据优先级最高。
 
    通过实现 MultiTabManageViewControllerDatasource 的代理方法 headItemViewForMultiTabView:withframe:atIndex: 提供自定义的标签按钮视图样式。  ＊注意＊总是需要实现该代理方法，而且自定义的标签按钮视图的 frame 要设置为代理方法 headItemViewForMultiTabView:withframe:atIndex: 所提供的 frame 值。
 
 
    若果需要监听标签按钮点击的事件可以实现 MultiTabManageViewControllerDelegate 的代理方法 multiTabView:didSelectedAtIndex: 来监听。
 
   
    ＊要确保提供的（或默认的）itemsCount 值与 controllers.count 的值保持一致＊
    ＊应该先设置好必要的属性后再调用 showInView: 方法显示该控件＊
    ＊如果自定义的标签按钮饱含 ImageView 要将其交互功能打开＊
 */
//
//

#import "MultiTabManageViewController.h"

@interface MultiTabManageViewController ()

@property(strong, nonatomic) UIView* superContentView;
@property(strong, nonatomic) UIView* headContentView;
@property(strong, nonatomic) UIView* bodyContentView;
//@property(strong, nonatomic) NSMutableArray* controllers;
@property(strong, nonatomic) NSMutableArray* innerItemViews;
// 默认数据
//@property(assign, nonatomic) CGFloat headViewHeight;
//@property(assign, nonatomic) NSInteger itemsCount;
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
    return self;
}

-(void)setControllers:(NSMutableArray *)controllers {
    _controllers = [controllers mutableCopy];
    //[self clearNoUseUI]; /////////////
    //[self startShow]; /////////////
    
    //[self setUpUI];  // 每次设置不同的一组controllers都会重新绘制UI
}

#pragma mark 自定义韩式
-(void)showInView:(UIView*)view {
    self.superContentView = view;
    [view addSubview:self.view];
    [self.view setFrame:view.bounds];
    [self setUpUI];
    
    //[self.view layoutSubviews];
}

-(void)clearNoUseUI {
    if (self.datasource != nil && [self.datasource respondsToSelector:@selector(viewControllerForMultiTabView:atIndex:)]) {
        [self.controllers removeAllObjects];
    }
    [self.innerItemViews removeAllObjects];
    
    [self.headContentView removeFromSuperview];
    self.headContentView = nil;
    [self.bodyContentView removeFromSuperview];
    self.bodyContentView = nil;
    
    //self.headViewHeight = 50;
    self.itemsCount = 3;
    self.currSelectedIndex = 0;
    self.isUseDatasurceVC = true;
    self.currDisplayController = nil;
}

-(void)setUpData {
    self.controllers = [[NSMutableArray alloc] init];
    self.innerItemViews = [[NSMutableArray alloc] init];
    
    self.headViewHeight = 50;
    self.itemsCount = 3;
    self.currSelectedIndex = 0;
    self.configItemTAg = 1000;
    self.isUseDatasurceVC = true;
}

-(void)setUpUI {
    [self clearNoUseUI];
    NSLog(@"controllers count = %d", _controllers.count);
    if (self.datasource != nil && [self.datasource respondsToSelector:@selector(heightForHeadContentView:)]) {
        self.headViewHeight = [self.datasource heightForHeadContentView:self];
    }
    self.headContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.headViewHeight)];
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
        NSLog(@"i = %d", i);
        CGRect itemF = CGRectMake(i*itemW+itemX, itemY, itemW, itemH);
        UIView* innerItem = [[UIView alloc] init]; // 可变
        if (self.datasource != nil && [self.datasource respondsToSelector:@selector(headItemViewForMultiTabView:withframe:atIndex:)]) {
            innerItem = [self.datasource headItemViewForMultiTabView:self withframe:itemF atIndex:i];
        }
        [innerItem setFrame:CGRectMake(i*itemW+itemX, itemY, itemW, itemH)];
//        [innerItem setNeedsLayout];
//        [innerItem layoutIfNeeded];
//        [innerItem layoutSubviews];
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
    }
    
    if (self.controllers.count > 0) {
        [self startShow];
    }
    
    NSLog(@"controllers count = %d", _controllers.count);
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
    [selView setBackgroundColor:[UIColor blackColor]];
    
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
    [view setBackgroundColor:[UIColor blackColor]];
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
    //NSLog(@"This method is not implemente yet");
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
