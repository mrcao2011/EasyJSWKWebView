//
//  EasyJSWKWebViewProxyDelegate.h
//  EasyJSWKWebViewSample
//
//  Created by mr.cao on 16/11/10.
//  Copyright © 2016年 mr.cao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
@interface EasyJSWKWebViewProxyDelegate : NSObject<WKNavigationDelegate>


@property (nonatomic,weak) id<WKNavigationDelegate> realNavigationDelegate;


- (void) addJavascriptInterfaces:(NSObject*) interface WithName:(NSString*) name;
@end
