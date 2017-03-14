//
//  IQEngUIAVCaptureSessionView_base.h
//  自定义相机成像基类
//
//  Created by 力王 on 16/11/17.
//  Copyright © 2016年 Herson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "UIImage+IQEngUICamera.h"
#import "UIView+IQEngUICamera.h"


//添加enum类型与NSString转换的便捷宏###########################{
//enum=>NSString
#define AS_EnumValueToNSString(EnumType)\
+ (NSString *)stringWith##EnumType:(EnumType)value;
#define DEF_EnumValueToNSString(EnumType,__staticMapDictionary)\
+ (NSString *)stringWith##EnumType:(EnumType)enumValue{\
static NSDictionary<NSNumber*,NSString *> *staticMap;\
if(!staticMap){\
NSDictionary *mapDictionary = (__staticMapDictionary);\
NSMutableDictionary<NSNumber *,NSString *> *map = [[NSMutableDictionary alloc] initWithCapacity:mapDictionary.count];\
for(id key in mapDictionary){\
id value = [mapDictionary objectForKey:key];\
if([key isKindOfClass:[NSNumber class]]){\
[map setObject:value forKey:key];\
}else{\
[map setObject:key forKey:value];\
}\
}\
staticMap = (map);\
}\
NSString *str = staticMap[@(enumValue)];\
if(!str){\
str = [@(enumValue) stringValue];\
}\
return str;\
}
//NSString=>enum
#define AS_EnumValueFromNSString(EnumType)\
- (EnumType)EnumType;
#define DEF_EnumValueFromNSString(EnumType,__staticMapDictionary)\
- (EnumType)EnumType{\
static NSDictionary<NSString *,NSNumber *> *staticMap;\
if(!staticMap){\
NSDictionary *mapDictionary = (__staticMapDictionary);\
NSMutableDictionary<NSString *,NSNumber *> *map = [[NSMutableDictionary alloc] initWithCapacity:mapDictionary.count];\
for (id key in mapDictionary) {\
id value = [mapDictionary objectForKey:key];\
if([key isKindOfClass:[NSNumber class]]){\
[map setObject:key forKey:value];\
}else{\
[map setObject:value forKey:key];\
}\
}\
staticMap = map;\
}\
EnumType enumValue = (EnumType)[staticMap[self] integerValue];\
return enumValue;\
}

//enum<=>NSString
#define AS_EnumValue_NSString(EnumType)\
AS_EnumValueToNSString(EnumType)\
AS_EnumValueFromNSString(EnumType)
#define DEF_EnumValue_NSString(EnumType,__staticMapDictionary)\
DEF_EnumValueToNSString(EnumType,__staticMapDictionary)\
DEF_EnumValueFromNSString(EnumType,__staticMapDictionary)

//定义NSString(enum)的类别
#define AS_EnumTypeCategoryToNSString(EnumType)\
@interface NSString(EnumType)\
AS_EnumValue_NSString(EnumType)\
@end
#define DEF_EnumTypeCategoryToNSString(EnumType,__staticMapDictionary)\
@implementation NSString(EnumType)\
DEF_EnumValue_NSString(EnumType,(__staticMapDictionary))\
@end

//添加enum类型数据从NSDictionary中获取的便捷宏
//NSDictionary[path]|otherwise=>enum
#define AS_EnumValueFromNSDictionaryAtPathAndOtherwise(EnumType)\
- (EnumType)EnumType##AtPath:(NSString *)path otherwise:(EnumType)otherwise;
#define DEF_EnumValueFromNSDictionaryAtPathAndOtherwise(EnumType)\
- (EnumType)EnumType##AtPath:(NSString *)path otherwise:(EnumType)otherwise{\
EnumType enumValue = otherwise;\
id obj = [self valueForKeyPath:path];\
if(obj==[NSNull null]){\
obj = nil;\
}\
if(obj){\
if([obj isKindOfClass:[NSNumber class]]){\
enumValue = (EnumType)[(NSNumber *)obj integerValue];\
}else if([obj isKindOfClass:[NSString class]]){\
NSString *str = (NSString *)obj;\
NSScanner *scanner = [[NSScanner alloc] initWithString:str];\
NSInteger value = 0;\
if([scanner scanInteger:&value]&&scanner.isAtEnd){\
enumValue = (EnumType)value;\
}else{\
enumValue = [str EnumType];\
}\
}else{\
enumValue = [[obj description] EnumType];\
}\
}\
return enumValue;\
}

//NSDictionary[path]=>enum
#define AS_EnumValueFromNSDictionaryAtPath(EnumType)\
- (EnumType)EnumType##AtPath:(NSString *)path;
#define DEF_EnumValueFromNSDictionaryAtPath(EnumType)\
- (EnumType)EnumType##AtPath:(NSString *)path{\
EnumType enumValue = (EnumType)0;\
id obj = [self valueForKeyPath:path];\
if(obj==[NSNull null]){\
obj = nil;\
}\
if(obj){\
if([obj isKindOfClass:[NSNumber class]]){\
enumValue = (EnumType)[(NSNumber *)obj integerValue];\
}else if([obj isKindOfClass:[NSString class]]){\
NSString *str = (NSString *)obj;\
NSScanner *scanner = [[NSScanner alloc] initWithString:str];\
NSInteger value = 0;\
if([scanner scanInteger:&value]&&scanner.isAtEnd){\
enumValue = (EnumType)value;\
}else{\
enumValue = [str EnumType];\
}\
}else{\
enumValue = [[obj description] EnumType];\
}\
}\
return enumValue;\
}

//NSDictionary[path]|otherwise=>enum,NSDictionary[path]=>enum
#define AS_EnumValueFromNSDictionary(EnumType)\
AS_EnumValueFromNSDictionaryAtPathAndOtherwise(EnumType)\
AS_EnumValueFromNSDictionaryAtPath(EnumType)
#define DEF_EnumValueFromNSDictionary(EnumType)\
DEF_EnumValueFromNSDictionaryAtPathAndOtherwise(EnumType)\
DEF_EnumValueFromNSDictionaryAtPath(EnumType)

//定义NSDictionary(enum)的类别
#define AS_EnumTypeCategoryToNSDictionary(EnumType)\
@interface NSDictionary(EnumType)\
AS_EnumValueFromNSDictionary(EnumType)\
@end
#define DEF_EnumTypeCategoryToNSDictionary(EnumType)\
@implementation NSDictionary(EnumType)\
DEF_EnumValueFromNSDictionary(EnumType)\
@end

//给Enum添加NSString与NSDictionry的category
//__staticMapDictionary为NSDicionary<NSNumber *,NSString *>,key为enum取值的NSNumber,value为enum值对应的NSString,例如:DEF_EnumTypeCategories(UIViewAnimationCurve,(@{@(UIViewAnimationCurveEaseInOut):@"EaseInOut",@(UIViewAnimationCurveEaseIn):@"EaseIn",@(UIViewAnimationCurveEaseOut):@"EaseOut",@(UIViewAnimationCurveLinear):@"Linear"}))
#define AS_EnumTypeCategories(EnumType)\
AS_EnumTypeCategoryToNSString(EnumType)\
AS_EnumTypeCategoryToNSDictionary(EnumType)
#define DEF_EnumTypeCategories(EnumType,__staticMapDictionary)\
DEF_EnumTypeCategoryToNSString(EnumType,__staticMapDictionary)\
DEF_EnumTypeCategoryToNSDictionary(EnumType)

//添加enum类型与NSString转换的便捷宏###########################}



//添加Mask类型与NSString转换的便捷宏###########################{
//OptionMask掩码值=>NSString
#define AS_OptionValue_NSString(OptionType)\
+ (NSString *)stringWithOPTIONS##OptionType:(OptionType)optionValue;

#define DEF_OptionValue_NSString(OptionType,__staticMapDictionary)\
+ (NSString *)stringWithOPTIONS##OptionType:(OptionType)optionValue{\
NSMutableArray<NSString *> *masks = [[NSMutableArray alloc] init];\
static NSDictionary<NSNumber *,NSString *> *staticMap;\
if(!staticMap){\
NSDictionary *mapDictionary = (__staticMapDictionary);\
NSMutableDictionary<NSNumber *,NSString *> *map = [[NSMutableDictionary alloc] initWithCapacity:mapDictionary.count];\
for (id key in mapDictionary) {\
id value = [mapDictionary objectForKey:key];\
if([key isKindOfClass:[NSNumber class]]){\
[map setObject:value forKey:key];\
}else{\
[map setObject:key forKey:value];\
}\
}\
staticMap = map;\
}\
for (NSNumber *num in staticMap) {\
OptionType v = (OptionType)[num integerValue];\
if((optionValue&v)==v){\
NSString *s = staticMap[num];\
[masks addObject:s];\
}\
}\
NSString *str = [masks componentsJoinedByString:@"|"];\
return str;\
}
//添加Mask类型与NSString转换的便捷宏###########################}


typedef NS_ENUM(NSInteger, IQEngAVCaptureSessionPreset)  {
    IQEngAVCaptureSessionPresetLow = 0,
    IQEngAVCaptureSessionPresetHigh,
    IQEngAVCaptureSessionPresetPhoto,
    IQEngAVCaptureSessionPresetMedium,
    IQEngAVCaptureSessionPreset352x288,
    IQEngAVCaptureSessionPreset640x480,
    IQEngAVCaptureSessionPreset1280x720,
    IQEngAVCaptureSessionPreset1920x1080,
    IQEngAVCaptureSessionPreset3840x2160,
    IQEngAVCaptureSessionPresetiFrame960x540,
    IQEngAVCaptureSessionPresetInputPriority,
    IQEngAVCaptureSessionPresetiFrame1280x720
};
AS_EnumTypeCategories(IQEngAVCaptureSessionPreset);

@interface IQEngUIAVCaptureSessionView_base : UIView

//session：输入输出结合在一起，并开始启动捕获设备（摄像头）
@property (nonatomic, readonly) AVCaptureSession *session;
//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property(nonatomic, strong) AVCaptureDevice *device;
//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property (nonatomic, strong) AVCaptureDeviceInput *input;
//输出图片
@property (nonatomic ,strong) AVCaptureOutput *output;
//图像预览层，实时显示捕获的图像
@property (nonatomic ,readonly) AVCaptureVideoPreviewLayer *previewLayer;


//选择前后摄像头（默认为后摄像头）
@property(nonatomic, assign) AVCaptureDevicePosition devicePosition;
//设置图片品质（默认IQEngAVCaptureSessionPresetPhoto）
@property(nonatomic, assign) IQEngAVCaptureSessionPreset sessionPreset;
//闪光模式
@property(nonatomic, assign) AVCaptureFlashMode flashMode;
//是否显示关闭对焦功能 (默认为YES)
@property(nonatomic, assign) BOOL showFocusView;
/**
 根据前后置位置拿到相应的摄像头：

 @param position 前后摄像头枚举

 @return AVCaptureDevice 设备
 */
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position;
///**
// 拍照
// */
//-(void)takePhoto;

-(void)startRunning;//开始取景
- (void)stopRunning;//结束取景
@end
