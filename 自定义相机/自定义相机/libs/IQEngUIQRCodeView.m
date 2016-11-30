//
//  IQEngUIQRCodeView.m
//  自定义相机
//
//  Created by 力王 on 16/11/28.
//  Copyright © 2016年 Herson. All rights reserved.
//

#import "IQEngUIQRCodeView.h"
#import "UIImage+IQEngUICamera.h"

@interface IQEngUIQRCodeView ()
@property(nonatomic, strong) UIView *maskView;//contentView
@property(nonatomic, strong) UIImageView *scanLineView;//绿色色条
@property(nonatomic, strong) UIImageView *scanBGView;

@end

@implementation IQEngUIQRCodeView

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGRect f1 = self.maskViewFrame;
    UIBezierPath *aPath = [UIBezierPath bezierPathWithRect:self.bounds];
    [aPath appendPath:[[UIBezierPath bezierPathWithRoundedRect:f1 cornerRadius:1] bezierPathByReversingPath]];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = aPath.CGPath;
    self.maskView.layer.mask = maskLayer;
    
    CGRect f2 = f1;
    CGSize s1 = self.scanLineView.image.size;
    f2.size.height = s1.height/s1.width * f2.size.width;
    self.scanLineView.frame = f2;
}
-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        
        self.maskView  = [[UIView alloc] init];
        self.maskView.backgroundColor = [UIColor colorWithRed:10/255.0 green:10/255.0 blue:10/255.0 alpha:0.3];
        [self addSubview:self.maskView];
        
        self.scanLineView = [[UIImageView alloc] init];
        self.scanLineView.image = [UIImage imageNamed_IQEngUICamera:@"IQEngUICameraScanLine.png"];
        [self addSubview:self.scanLineView];
        
        self.scanBGView = [[UIImageView alloc] initWithImage:[UIImage imageNamed_IQEngUICamera:@"IQEngUICameraScanscanBg.png"]];
        [self addSubview:self.scanBGView];
        
        [self reloadFrame];
    }
    return self;
}
-(void)reloadFrame{
    
    CGRect f1 = self.maskViewFrame;
    f1.size.height = self.scanLineView.frame.size.height;
    
    CGRect f2 = f1;
    f2.origin.y = f1.origin.y + self.maskViewFrame.size.height - f1.size.height;
    
    __weak typeof(self) wself = self;
    [UIView animateWithDuration:4 animations:^{
        CGFloat orif1 = [[NSString stringWithFormat:@"%.2f",wself.scanLineView.frame.origin.y] floatValue];
        CGFloat orif2 = [[NSString stringWithFormat:@"%.2f",wself.maskViewFrame.origin.y] floatValue];
        wself.scanLineView.frame = orif1 == orif2?f2:f1;
    } completion:^(BOOL finished) {
        [wself reloadFrame];
    }];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    self.maskView.frame = bounds;
    self.scanBGView.frame = self.maskViewFrame;
}
@end
