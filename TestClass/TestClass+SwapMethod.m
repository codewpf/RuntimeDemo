//
//  TestClass+SwapMethod.m
//  LearnRuntime
//
//  Created by wpf on 2017/2/27.
//  Copyright © 2017年 wpf. All rights reserved.
//

#import "TestClass+SwapMethod.h"
#import "Runtime.h"

@implementation TestClass (SwapMethod)

- (void)swapMethod
{
    [Runtime methodSwap:[self class] method1:@selector(method1) method2:@selector(method2)];
}

- (void)method2
{
    [self method2];
    NSLog(@"可以在method1的基础上添加其他实现");
}

@end
