//
//  UIImage+IQEngUICamera.m
//  自定义相机
//
//  Created by 力王 on 16/11/30.
//  Copyright © 2016年 Herson. All rights reserved.
//

#import "UIImage+IQEngUICamera.h"

@implementation UIImage (IQEngUICamera)
+ (UIImage *)imageNamed_IQEngUICamera:(NSString *)name{
    
    NSBundle *boundle = [NSBundle bundleForIQEngUICamera];
    UIImage *image = [self imageNamed:name inBundle:boundle compatibleWithTraitCollection:nil];
    return image;
}
@end
