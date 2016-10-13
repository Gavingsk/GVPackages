//
//  GVViewController.m
//  GVPackages
//
//  Created by Gavingsk on 10/13/2016.
//  Copyright (c) 2016 Gavingsk. All rights reserved.
//

#import "GVViewController.h"
#import <GVPackages/GVPackge.h>

@interface GVViewController ()

@end

@implementation GVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)loadView{
    
    self.view = [UIView viewWithColor:[UIColor yellowColor] size:CGSizeZero];
    UIView *newView = [UIView new];
    
    //直接更改view的坐标
    newView.width = 100;
    newView.x = 100;
    newView.y = 100;
    newView.height = 100;
    newView.cornerRadius = 5;
    //支持16进制颜色
    UIColor *hexColor = [UIColor colorFromHexRGB:@"48AD32"];
    newView.backgroundColor = hexColor;
    [self.view addSubview:newView];
    
    //这一句
    __unsafe_unretained GVViewController *__weakSelf = self;
    //等价于
    GVWeekRef(self);
    // __weakSelf == __self;
    
    void(^block1)() = ^{
        
        [__weakSelf view];
        [__self view];
        
    };
    
    block1();
    
    UIWindow *window = __self.view.window;
    UIWindow *keyWindow = GVKeyWindow;
    NSString *str = [NSString stringWithFormat:@"%@%@%@",@"a",@"b",@"c",@"d"];
    NSString *newStr = GVString(@"%@%@%@",@"a",@"b");
    NSLog(@"%@",str);
    GVLog(@"%@",newStr); //在Release模式 不打印
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
