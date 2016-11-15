# EasyJSWKWebView

_Enable adding Javascript Interface to WKWebView like Android WebView_

类似与Android WebView，注册本地类对象和JS中类对象名称的方式实现Javascript与WKWebView的交互,基于[EasyJSWebView(UIWebView)](https://github.com/dukeland/EasyJSWebView)移植到WKWebView

### `JS` 调用 `Objective-C`

#### 首先创建个类,类实例方法需要与 `js` 端方法名称保持一致
```
#import "testJavaScript.h"

@implementation testJavaScript

-(void)JSCallOC
{

}

-(void)OCCallJS
{

}
@end
```
#### 注册类对象给WKWebview
```diff
+ testJavaScript* bridge = [[testJavaScript alloc]init];
    
+ [_webView addJavascriptInterfaces:bridge WithJSObjName:@"testJavaScript"];    
```

在JS代码里面，调用Objective-C方法：

```diff
+ window.testJavaScript.JSCallOC();
```

### Objective-C调用JS
   
#### 直接调用WKWebView API 
   
```oc
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^ __nullable)(__nullable id, NSError * __nullable error))completionHandler;
```
即可  
  
> 例如：
  
```oc
[_webView evaluateJavaScript:[NSString  stringWithFormat:@"OCCallJS('%@')",@"厉害了world哥"]completionHandler:nil];
```

具体代码请参考工程代码