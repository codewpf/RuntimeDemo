//
//  TestClass.m
//  LearnRuntime
//
//  Created by wpf on 2017/2/26.
//  Copyright © 2017年 wpf. All rights reserved.
//

#import "TestClass.h"
#import "Runtime.h"


@interface OtherClass : NSObject

- (void)dynamicNoMehod:(NSString *)value;

@end

@implementation OtherClass

- (void)dynamicNoMehod:(NSString *)value
{
    NSLog(@"OtherClass+%@",value);
}

@end


@interface TestClass ()
{
    NSInteger _var1;
    int _var2;
    BOOL _var3;
    double _var4;
    float _var5;
}

@property (nonatomic, strong) NSMutableArray *privateProperty1;
@property (nonatomic, strong) NSNumber *privateProperty2;
@property (nonatomic, strong) NSDictionary *privateProperty3;

@end

@implementation TestClass

//- (id)copyWithZone:(nullable NSZone *)zone
//{
//    return [super ]
//}

- (instancetype)init
{
    if(self = [super init])
    {
        _var4 = 0.32f;
    }
    return self;
}


#pragma mark - Private
- (void)privateTestMethod1
{
    NSLog(@"privateTestMethod1");
}

- (void)privateTestMethod2
{
    NSLog(@"privateTestMethod2");
}

- (void)PrivateTestMehod3:(NSString *)value
{
    NSLog(@"PrivateTestMehod3 + %@", value);

}


#pragma mark - Public
+ (void)classMethod:(NSString *)value
{

}

- (void)publicTestMethod1:(NSString *)value1 second:(NSString *)value2
{

}

- (void)publicTestMethod2
{
    NSLog(@"publicTestMethod2");
}

- (void)PublicTestMethod3:(NSString *)value
{
    NSLog(@"PublicTestMethod3 + %@", value);
}




- (void)method1
{
    NSLog(@"我是method1的实现");
}

#pragma mark - 动态添加方法

- (void)dynamicAddMethod:(NSString *)value
{
    NSLog(@"我是动态添加的方法%@",value);
}


/**
 * 没有找到方法的实现 调用此方法
 * @param sel 未找到实现的方法名
 * @return 返回YES则不崩溃，添加方法实现
 */
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    return NO;
    [Runtime addMethod:self.class method:sel method:@selector(dynamicAddMethod:)];
    return YES;
}


/**
 * 把对象不存在的方法 发送给 存在本方法的对象
 * @param aSelector 不存在的方法
 * @return 存在该方法的对象
 */
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return self;
    return [OtherClass new];
}



- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (signature == nil)
    {
        signature = [NSMethodSignature signatureWithObjCTypes:"@@:"];
    }
    return signature;
}


/**
 *  不能传给其他对象则 自己处理
 */
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    OtherClass *other = [OtherClass new];
    SEL selector = [anInvocation selector];
    if ([other respondsToSelector:selector])
    {
        [anInvocation invokeWithTarget:other];
    }
    else
    {
        [self doesNotRecognizeSelector:selector];
    }

}



@end




@implementation SubClass
- (void)subPrivateMethod
{
    NSLog(@"subPrivateMethod");
}

- (void)subPublicTestMethod
{
    NSLog(@"subPublicTestMethod2");
}


@end
