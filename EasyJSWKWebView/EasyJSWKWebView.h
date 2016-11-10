//
//  EasyJSWKWebView.h
//  EasyJSWKWebViewSample
//
//  Created by mr.cao on 16/11/10.
//  Copyright © 2016年 mr.cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EasyJSWKWebViewProxyDelegate.h"

@interface EasyJSWKWebView : WKWebView


- (void) addJavascriptInterfaces:(NSObject*) interface WithName:(NSString*) name;

@end
