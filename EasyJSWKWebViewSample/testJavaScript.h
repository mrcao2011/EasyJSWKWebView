//
//  testJavaScript.h
//  EasyJSWKWebViewSample
//
//  Created by mr.cao on 16/11/10.
//  Copyright © 2016年 mr.cao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  void (^OCCallJSBolck)();
typedef  void (^JSCallOCBolck)();
@interface testJavaScript : NSObject

@property(copy,nonatomic)OCCallJSBolck ocCallJSBolck;
@property(copy,nonatomic)JSCallOCBolck jsCallOCBolck;
@end
