//
//  Runtime.h
//  RuntimeDemo
//
//  Created by wpf on 2017/3/1.
//  Copyright © 2017年 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface Runtime : NSObject

/**
 * 根据对象获取类名
 * @param object 相应对象
 * @return 类名
 */
+ (NSString *)getClassNameByObject:(id)object;

/**
 * 根据类获取类名
 * @param class 相应类
 * @return 类名
 */
+ (NSString *)getClassNameByClass:(Class)class;

/**
 * 获取实例成员变量
 * @param class 实例相应类
 * @param name 成员变量名称
 * @return 返回去掉“_”的属性名或者不存在
 */
+ (NSString *)getInstanceIvar:(Class)class name:(NSString *)name;

/**
 * 获取成员变量列表
 * @param class 相应类
 * @return 成员变量列表
 */
+ (NSArray *)getIvarList:(Class)class;

/**
 * 获取实例方法
 * @param class 实例相应类
 * @param name 类方法名称
 * @return 返回增加“_”的方法名或者不存在
 */
+ (NSString *)getInstanceMethod:(Class)class name:(SEL)name;

/**
 * 获取类方法
 * @param class 相应类
 * @param name 类方法名称
 * @return 返回增加“_”的方法名或者不存在
 * @note 该方法会查找父类，且class_copyMethodList不查找的类方法
 */
+ (NSString *)getClassMethod:(Class)class name:(SEL)name;

/**
 * 获取实例方法列表
 * @param class 相应类
 * @return 实例方法列表
 */
+ (NSArray *)getMethodList:(Class)class;

/**
 * 类是否遵循协议
 * @param class 相应类
 * @param protocolName 协议名称
 * @return 返回结果
 */
+ (BOOL)classConformsProtocol:(Class)class name:(NSString *)protocolName;

/**
 * 获取协议列表
 * @param class 相应类
 * @return 协议列表
 */
+ (NSArray *)getProtocolList:(Class)class;

/**
 * 在Runtime系统中注册一个方法
 * @note 官方解释中：sel_getUid和sel_registerName 的区别就是sel_registerName映射到一个选择器并返回一个选择器值
 */
+ (NSString *)resigterMethod:(NSString *)name;

/**
 * 获取属性列表
 * @param class 相应类
 * @return 属性列表
 */
+ (NSArray *)getPropertyList:(Class)class;

/**
 * 给类添加方法及实现
 * @param class 相应类
 * @param methodSel 方法名
 * @param methodSelImplementation 实现的方法名
 * @return 是否添加成功
 */
+ (BOOL)addMethod:(Class)class method:(SEL)methodSel method:(SEL)methodSelImplementation;

/**
 * 替换类的方法
 * @param class 相应类
 * @param methodSel 要被替换的方法名
 * @param methodSelImplementation 替换的方法名
 * @note 如果被替换的方法不存在就执行class_addMethod,如果存在则执行class_replaceMethod且types就忽略掉。
 */
+ (BOOL)replaceMethod:(Class)class method:(SEL)methodSel method:(SEL)methodSelImplementation;

/**
 * 添加成员变量
 * @note 不能给已经存在的类添加变量，只能添加一个类并给其添加变量
 */
+ (Class)addIvarClassName:(NSString *)className ivarName:(NSString *)iVarName;

/**
 * 给类添加属性
 * 属性，一般包括四个定义，原子性、修饰符、类型、名称，另外还有一些只读等定义（可参考下面链接，也可以自己尝试打印属性查看）
 * http://blog.csdn.net/myzlk/article/details/50815381
 */
+ (BOOL)addProperty:(Class)class typeName:(NSString *)typeName propertyName:(NSString *)propertyName;

/**
 * 方法交换
 * @param class 交换相应类
 * @param method1 方法1
 * @param method2 方法2
 */
+ (void)methodSwap:(Class)class method1:(SEL)method1 method2:(SEL)method2;

@end
