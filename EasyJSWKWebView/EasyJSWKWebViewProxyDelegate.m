//
//  EasyJSWKWebViewProxyDelegate.m
//  EasyJSWKWebViewSample
//
//  Created by mr.cao on 16/11/10.
//  Copyright © 2016年 mr.cao. All rights reserved.
//

#import "EasyJSWKWebViewProxyDelegate.h"
#import <objc/runtime.h>

NSString* INJECT_JS = @"window.EasyJS = {\
__callbacks: {},\
\
invokeCallback: function (cbID, removeAfterExecute){\
var args = Array.prototype.slice.call(arguments);\
args.shift();\
args.shift();\
\
for (var i = 0, l = args.length; i < l; i++){\
args[i] = decodeURIComponent(args[i]);\
}\
\
var cb = EasyJS.__callbacks[cbID];\
if (removeAfterExecute){\
EasyJS.__callbacks[cbID] = undefined;\
}\
return cb.apply(null, args);\
},\
\
call: function (obj, functionName, args){\
var formattedArgs = [];\
for (var i = 0, l = args.length; i < l; i++){\
if (typeof args[i] == \"function\"){\
formattedArgs.push(\"f\");\
var cbID = \"__cb\" + (+new Date);\
EasyJS.__callbacks[cbID] = args[i];\
formattedArgs.push(cbID);\
}else{\
formattedArgs.push(\"s\");\
formattedArgs.push(encodeURIComponent(args[i]));\
}\
}\
\
var argStr = (formattedArgs.length > 0 ? \":\" + encodeURIComponent(formattedArgs.join(\":\")) : \"\");\
\
var iframe = document.createElement(\"IFRAME\");\
iframe.setAttribute(\"src\", \"easy-js:\" + obj + \":\" + encodeURIComponent(functionName) + argStr);\
document.documentElement.appendChild(iframe);\
iframe.parentNode.removeChild(iframe);\
iframe = null;\
},\
\
inject: function (obj, methods){\
window[obj] = {};\
var jsObj = window[obj];\
\
for (var i = 0, l = methods.length; i < l; i++){\
(function (){\
var method = methods[i];\
var jsMethod = method.replace(new RegExp(\":\", \"g\"), \"\");\
jsObj[jsMethod] = function (){\
return EasyJS.call(obj, method, Array.prototype.slice.call(arguments));\
};\
})();\
}\
}\
};";
@interface EasyJSWKWebViewProxyDelegate()
{
    
}

@property (nonatomic, strong) NSMutableDictionary* javascriptInterfaces;



@end
@implementation EasyJSWKWebViewProxyDelegate


- (void) addJavascriptInterfaces:(NSObject*) interface WithName:(NSString*) name{
    if (! self.javascriptInterfaces){
        self.javascriptInterfaces = [[NSMutableDictionary alloc] init];
    }
    
    [self.javascriptInterfaces setValue:interface forKey:name];
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.realNavigationDelegate webView:webView didFailProvisionalNavigation:navigation withError:error];
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.realNavigationDelegate webView:webView didFinishNavigation:navigation];
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString *requestString =[[navigationAction.request URL]absoluteString];
    
    if ([requestString hasPrefix:@"easy-js:"]) {
        NSArray *components = [requestString componentsSeparatedByString:@":"];
        
        NSString* obj = (NSString*)[components objectAtIndex:1];
        NSString* method = [(NSString*)[components objectAtIndex:2]
                            stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSObject* interface = [self.javascriptInterfaces objectForKey:obj];
        
        // execute the interfacing method
        SEL selector = NSSelectorFromString(method);
        NSMethodSignature* sig = [[interface class] instanceMethodSignatureForSelector:selector];
        NSInvocation* invoker = [NSInvocation invocationWithMethodSignature:sig];
        invoker.selector = selector;
        invoker.target = interface;
        
        NSMutableArray* args = [[NSMutableArray alloc] init];
        
        if ([components count] > 3){
            NSString *argsAsString = [(NSString*)[components objectAtIndex:3]
                                      stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSArray* formattedArgs = [argsAsString componentsSeparatedByString:@":"];
            for (int i = 0, j = 0, l = [formattedArgs count]; i < l; i+=2, j++){
                NSString* type = ((NSString*) [formattedArgs objectAtIndex:i]);
                NSString* argStr = ((NSString*) [formattedArgs objectAtIndex:i + 1]);
                
                if ([@"s" isEqualToString:type]){
                    NSString* arg = [argStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    [args addObject:arg];
                    [invoker setArgument:&arg atIndex:(j + 2)];
                }
            }
        }
        [invoker invoke];
        
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {

    [self.realNavigationDelegate webView:webView didStartProvisionalNavigation:navigation];
    
    
    if (! self.javascriptInterfaces){
        self.javascriptInterfaces = [[NSMutableDictionary alloc] init];
    }
    
    NSMutableString* injection = [[NSMutableString alloc] init];
    
    //inject the javascript interface
    for(id key in self.javascriptInterfaces) {
        NSObject* interface = [self.javascriptInterfaces objectForKey:key];
        
        [injection appendString:@"EasyJS.inject(\""];
        [injection appendString:key];
        [injection appendString:@"\", ["];
        
        unsigned int mc = 0;
        Class cls = object_getClass(interface);
        Method * mlist = class_copyMethodList(cls, &mc);
        for (int i = 0; i < mc; i++){
            [injection appendString:@"\""];
            [injection appendString:[NSString stringWithUTF8String:sel_getName(method_getName(mlist[i]))]];
            [injection appendString:@"\""];
            
            if (i != mc - 1){
                [injection appendString:@", "];
            }
        }
        
        free(mlist);
        
        [injection appendString:@"]);"];
    }
    
    
    NSString* js = INJECT_JS;
    [webView evaluateJavaScript:js completionHandler:nil];
    [webView evaluateJavaScript:injection completionHandler:nil];
    
}

- (void)dealloc{
    if (self.javascriptInterfaces){
        
        self.javascriptInterfaces = nil;
    }
    
    if (self.realNavigationDelegate){
        
        self.realNavigationDelegate = nil;
    }

}


@end
