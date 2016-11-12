//
//  ViewController.m
//  EasyJSWKWebViewSample
//
//  Created by mr.cao on 16/11/10.
//  Copyright © 2016年 mr.cao. All rights reserved.
//

#import "ViewController.h"
#import "EasyJSWKWebView.h"
#import "testJavaScript.h"

@interface ViewController ()
{
    EasyJSWKWebView *_webView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _webView = [[EasyJSWKWebView alloc] initWithFrame:CGRectMake(0,0,
                                                              self.view.frame.size.width,
                                                              self.view.frame.size.height)];
    
    _webView.backgroundColor = [UIColor clearColor];
    _webView.clipsToBounds = YES;
    [self.view addSubview:_webView];
    NSString *path=[[NSBundle mainBundle]pathForResource:@"index" ofType:@"html"];
         NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]
                                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                        timeoutInterval:60.0];
    [_webView loadRequest:request];
    testJavaScript* bridge = [[testJavaScript alloc]init];
    [_webView addJavascriptInterfaces:bridge WithJSObjName:@"testJavaScript"];
    bridge.ocCallJSBolck=^()
    {
       [_webView evaluateJavaScript:[NSString  stringWithFormat:@"OCCallJS('%@')",@"厉害了world哥"]completionHandler:nil];
    
    };
    bridge.jsCallOCBolck=^()
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"js调用oc" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [alertView show];
    };
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
