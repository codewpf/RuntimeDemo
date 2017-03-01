//
//  main.m
//  RuntimeDemo
//
//  Created by wpf on 2017/3/1.
//  Copyright © 2017年 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TestClass.h"
#import "TestClass+SwapMethod.h"
#import "TestClass+AssociatedObject.h"

#import "Runtime.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        
        TestClass *test = [TestClass new];
        
        
        NSLog(@"\n根据对象获取类名:\n%@",[Runtime getClassNameByObject:test]);
        
        NSLog(@"\n根据类获取类名:\n%@",[Runtime getClassNameByClass:test.class]);
        
        NSLog(@"\n获取实例成员变量:\n%@",[Runtime getInstanceIvar:test.class name:@"_var4"]);
        
        NSLog(@"\n获取成员变量列表:\n%@",[Runtime getIvarList:test.class]);
        
        NSLog(@"\n获取实例方法:\n%@",[Runtime getInstanceMethod:test.class name:@selector(privateTestMethod1)]);
        
        NSLog(@"\n获取类方法:\n%@",[Runtime getClassMethod:test.class name:@selector(classMethod:)]);
        
        NSLog(@"\n获取实例方法列表:\n%@",[Runtime getMethodList:test.class]);
        
        NSLog(@"\n类是否遵循协议:\n%d,NSCoding",[Runtime classConformsProtocol:test.class name:@"NSCoding"]);
        
        NSLog(@"\n获取协议列表:\n%@",[Runtime getProtocolList:test.class]);
        
        NSLog(@"\n在Runtime系统中注册一个方法:\n%@",[Runtime resigterMethod:@"publicTestMethod2"]);
        
        NSLog(@"\n获取属性列表:\n%@",[Runtime getPropertyList:test.class]);
        
        
        // 增加方法
        SubClass *sub = [SubClass new];
        BOOL result1 = [Runtime addMethod:sub.class method:@selector(publicTestMethod2) method:@selector(subPublicTestMethod)];
        if(result1)
        {
            NSLog(@"添加方法成功");
            [sub publicTestMethod2];
        }
        else
        {
            NSLog(@"添加方法不成功");
        }
        
        // 替换方法
        BOOL result2 = [Runtime replaceMethod:sub.class method:@selector(subPublicTestMethod) method:@selector(subPrivateMethod)];
        if(result2)
        {
            NSLog(@"替换方法成功");
            [sub subPublicTestMethod];
        }
        else
        {
            NSLog(@"替换方法不成功");
        }
        
        // 添加变量
        Class MyClass = [Runtime addIvarClassName:@"AddClass" ivarName:@"addIvar"];
        if(MyClass)
        {
            NSLog(@"添加变量成功");
            id addClass = [MyClass new];
            NSLog(@"%@",[Runtime getIvarList:[addClass class]]);
        }
        else
        {
            NSLog(@"添加变量不成功");
        }
        
        // 添加属性
        BOOL result3 = [Runtime addProperty:test.class typeName:NSStringFromClass([TestClass class]) propertyName:@"addProperty"];
        if(result3)
        {
            NSLog(@"添加属性成功");
            NSLog(@"属性添加后%@",[Runtime getPropertyList:test.class]);
        }
        else
        {
            NSLog(@"添加属性不成功");
        }
        
        [test swapMethod];
        [test method1];
        NSLog(@"------");
        [test method2];

        
    }
    return 0;
}
