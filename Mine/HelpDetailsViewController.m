//
//  HelpDetailsViewController.m
//  Financeteam
//
//  Created by Zccf on 16/9/28.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "HelpDetailsViewController.h"
#define imageWidth 256/2.0
#define imageHeigt 227
#define space (kScreenWidth-256)/3.0
#import <WebKit/WebKit.h>
@interface HelpDetailsViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) WKWebView *webView;
@end

@implementation HelpDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"测试webView";
//    self.webView = [WKWebView alloc]initWithFrame:self.view.frame configuration:<#(nonnull WKWebViewConfiguration *)#>
    // Do any additional setup after loading the view.
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
