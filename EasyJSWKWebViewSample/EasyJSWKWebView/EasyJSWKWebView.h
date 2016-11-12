//
//  EasyJSWKWebView.h
//  EasyJSWKWebViewSample
//
//  Created by mr.cao on 16/11/10.
//  Copyright © 2016年 mr.cao. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface EasyJSWKWebView : WKWebView


/**
 *
 *
 *  @param interface 
 *  @param name      js对象名字
 */
- (void) addJavascriptInterfaces:(NSObject*) interface WithJSObjName:(NSString*) name;

@end
