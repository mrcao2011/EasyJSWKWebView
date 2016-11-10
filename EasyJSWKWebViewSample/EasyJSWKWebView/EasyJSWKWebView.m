//
//  EasyJSWKWebView.m
//  EasyJSWKWebViewSample
//
//  Created by mr.cao on 16/11/10.
//  Copyright © 2016年 mr.cao. All rights reserved.
//

#import "EasyJSWKWebView.h"

@interface EasyJSWKWebView()

@property (nonatomic, strong) EasyJSWKWebViewProxyDelegate* proxyDelegate;

@end

@implementation EasyJSWKWebView

- (id)init{
    self = [super init];
    if (self) {
        [self initEasyJS];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initEasyJS];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    if (self){
        [self initEasyJS];
    }
    
    return self;
}

- (void) initEasyJS{
    self.proxyDelegate = [[EasyJSWKWebViewProxyDelegate alloc] init];
    self.navigationDelegate = self.proxyDelegate;
}

- (void) setDelegate:(id<WKNavigationDelegate>)delegate{
    if (delegate != self.proxyDelegate){
        self.proxyDelegate.realNavigationDelegate = delegate;
    }else{
        [super setNavigationDelegate:delegate];
    }
}

- (void) addJavascriptInterfaces:(NSObject*) interface WithName:(NSString*) name{
    [self.proxyDelegate addJavascriptInterfaces:interface WithName:name];
}

- (void) dealloc{
    
    self.proxyDelegate = nil;
}
@end
