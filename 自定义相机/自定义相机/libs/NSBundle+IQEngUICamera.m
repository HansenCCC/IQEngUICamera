//
//  NSBundle+IQEngUICamera.m
//  自定义相机
//
//  Created by 力王 on 16/11/30.
//  Copyright © 2016年 Herson. All rights reserved.
//

#import "NSBundle+IQEngUICamera.h"

@implementation NSBundle (IQEngUICamera)

+(instancetype)bundleForIQEngUICamera{
    
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"IQEngUICamera" ofType:@"bundle"]];
    return  bundle;
}

@end
