# EasyJSWKWebView

Enable adding Javascript Interface to WKWebView like Android WebView


类似与Android WebView，注册本地类对象和JS中类对象名称的方式实现Javascript与WKWebView的交互,基于[EasyJSWebView(UIWebView)](https://github.com/dukeland/EasyJSWebView)移植到WKWebView

###JS调用Objective-C

首先创建个类,类实例方法需要与js端方法名称保持一致

    ```objc
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
   
 注册类对象给WKWebview
 
    ```objc
     
    testJavaScript* bridge = [[testJavaScript alloc]init];
    
    [_webView addJavascriptInterfaces:bridge WithJSObjName:@"testJavaScript"];   
    
      ``` 

在JS代码里面，调用Objective-C方法：

   ```javascript
    window.testJavaScript.JSCallOC();
  ```  
    
    
###Objective-C调用JS
   
   直接调用WKWebView API 
   
    ```objc 
    - (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^ __nullable)(__nullable id, NSError * __nullable error))completionHandler; 
       
      ```  
  即可  
  
  
  例如：
  
     ```objc
    [_webView evaluateJavaScript:[NSString  stringWithFormat:@"OCCallJS('%@')",@"厉害了world哥"]completionHandler:nil];
   
      ``` 

具体代码请参考工程代码