//
//  testJavaScript.m
//  EasyJSWKWebViewSample
//
//  Created by mr.cao on 16/11/10.
//  Copyright © 2016年 mr.cao. All rights reserved.
//

#import "testJavaScript.h"

@implementation testJavaScript

-(void)JSCallOC
{
    if(self.jsCallOCBolck)
    {
        self.jsCallOCBolck();
    }
    
    
}

-(void)OCCallJS
{
    if(self.ocCallJSBolck)
    {
        self.ocCallJSBolck();
    }
}
@end
