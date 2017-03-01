//
//  Runtime.m
//  RuntimeDemo
//
//  Created by wpf on 2017/3/1.
//  Copyright © 2017年 wpf. All rights reserved.
//

#import "Runtime.h"

@implementation Runtime

/**
 * 根据对象获取类名
 * @param object 相应对象
 * @return 类名
 */
+ (NSString *)getClassNameByObject:(id)object
{
    const char *className = object_getClassName(object);
    return [NSString stringWithUTF8String:className];
}

/**
 * 根据类获取类名
 * @param class 相应类
 * @return 类名
 */
+ (NSString *)getClassNameByClass:(Class)class
{
    const char *className = class_getName(class);
    return [NSString stringWithUTF8String:className];
}

/**
 * 获取实例成员变量
 * @param class 实例相应类
 * @param name 成员变量名称
 * @return 返回去掉“_”的属性名或者不存在
 */
+ (NSString *)getInstanceIvar:(Class)class name:(NSString *)name
{
    /*
     关于 获取类成员变量 class_getClassVariable 没有返回任何值
     官方解释 class_getClassVariable(cls, name) merely calls class_getInstanceVariable(cls->isa, name).
     详情 如下：
     https://lists.apple.com/archives/objc-language/2008/Feb/msg00021.html
     
     但在代码中 “只是调用了 class_getInstanceVariable” 也不成立。
     */
    Ivar ivar = class_getInstanceVariable(class, name.UTF8String);
    if (ivar)
    {
        return [[NSString stringWithUTF8String:ivar_getName(ivar)] substringFromIndex:1];
    }
    else
    {
        return @"不存在";
    }
}

/**
 * 获取成员变量列表
 * @param class 相应类
 * @return 成员变量列表
 */
+ (NSArray *)getIvarList:(Class)class
{
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList(class, &count);
    NSMutableArray *mutabList = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i++)
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
        const char *ivarName = ivar_getName(ivarList[i]);
        const char *ivarType = ivar_getTypeEncoding(ivarList[i]);
        dict[@"ivarName"] = [NSString stringWithUTF8String:ivarName];
        dict[@"type"] = [NSString stringWithUTF8String:ivarType];
        [mutabList addObject:dict];
    }
    free(ivarList);
    
    return [NSArray arrayWithArray:mutabList];
}

/**
 * 获取实例方法
 * @param class 实例相应类
 * @param name 类方法名称
 * @return 返回增加“_”的方法名或者不存在
 */
+ (NSString *)getInstanceMethod:(Class)class name:(SEL)name
{
    Method method = class_getInstanceMethod(class, name);
    
    if(method)
    {
        SEL name = method_getName(method);
        const char *type = method_getTypeEncoding(method);
        return [NSString stringWithFormat:@"_%@+%@",NSStringFromSelector(name),[NSString stringWithUTF8String:type]];
    }
    else
    {
        return @"不存在";
    }
}

/**
 * 获取类方法
 * @param class 相应类
 * @param name 类方法名称
 * @return 返回增加“_”的方法名或者不存在
 * @note 该方法会查找父类，且class_copyMethodList不查找的类方法
 */
+ (NSString *)getClassMethod:(Class)class name:(SEL)name
{
    Method method = class_getClassMethod(class, name);
    
    if(method)
    {
        SEL name = method_getName(method);
        const char *type = method_getTypeEncoding(method);
        return [NSString stringWithFormat:@"_%@+%@",NSStringFromSelector(name),[NSString stringWithUTF8String:type]];
    }
    else
    {
        return @"不存在";
    }
}

/**
 * 获取实例方法列表
 * @param class 相应类
 * @return 实例方法列表
 */
+ (NSArray *)getMethodList:(Class)class
{
    unsigned int count = 0;
    Method *methodList = class_copyMethodList(class, &count);
    NSMutableArray *mutabList = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i++)
    {
        SEL methodName = method_getName(methodList[i]);
        [mutabList addObject:NSStringFromSelector(methodName)];
    }
    
    free(methodList);
    return [NSArray arrayWithArray:mutabList];
}

/**
 * 类是否遵循协议
 * @param class 相应类
 * @param protocolName 协议名称
 * @return 返回结果
 */
+ (BOOL)classConformsProtocol:(Class)class name:(NSString *)protocolName
{
    Protocol *protocol = objc_getProtocol(protocolName.UTF8String);
    
    return class_conformsToProtocol(class, protocol);
}

/**
 * 获取协议列表
 * @param class 相应类
 * @return 协议列表
 */
+ (NSArray *)getProtocolList:(Class)class
{
    unsigned int count = 0;
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList(class, &count);
    NSMutableArray *mutabList = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i++)
    {
        const char *protocolName = protocol_getName(protocolList[i]);
        [mutabList addObject:[NSString stringWithUTF8String:protocolName]];
    }
    
    free(protocolList);
    return [NSArray arrayWithArray:mutabList];
}

/**
 * 在Runtime系统中注册一个方法
 * @note 官方解释中：sel_getUid和sel_registerName 的区别就是sel_registerName映射到一个选择器并返回一个选择器值
 */
+ (NSString *)resigterMethod:(NSString *)name
{
    SEL sel1 = sel_getUid(name.UTF8String);
    NSString *str = @"";
    if(sel1)
    {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"sel_getUid %s 存在",sel_getName(sel1)]];
        
    }
    else
    {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"sel_getUid %s 不存在",sel_getName(sel1)]];
    }
    
    SEL sel2 = sel_registerName(name.UTF8String);
    
    if(sel2)
    {
        return [str stringByAppendingString:[NSString stringWithFormat:@"\nsel_registerName %s 存在",sel_getName(sel2)]];
        
    }
    else
    {
        return [str stringByAppendingString:[NSString stringWithFormat:@"\nsel_registerName %s 不存在",sel_getName(sel2)]];
    }
    
}

/**
 * 获取属性列表
 * @param class 相应类
 * @return 属性列表
 */
+ (NSArray *)getPropertyList:(Class)class
{
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList(class, &count);
    NSMutableArray *mutabList = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i< count; i++)
    {
        
        const char *propertyName = property_getName(propertyList[i]);
        [mutabList addObject:[NSString stringWithUTF8String:propertyName]];
    }
    free(propertyList);
    return [NSArray arrayWithArray:mutabList];
}

/**
 * 给类添加方法及实现
 * @param class 相应类
 * @param methodSel 要添加的方法名
 * @param methodSelImplementation 实现的方法名
 * @return 是否添加成功
 * @note 可以覆盖父类的方法，但是不能添加当前类已经存在的方法否则返回NO
 */
+ (BOOL)addMethod:(Class)class method:(SEL)methodSel method:(SEL)methodSelImplementation
{
    Method method = class_getInstanceMethod(class, methodSelImplementation);
    IMP methodImp = method_getImplementation(method);
    const char *type = method_getTypeEncoding(method);
    BOOL result = class_addMethod(class, methodSel, methodImp, type);
    return result;
}

/**
 * 替换类的方法
 * @param class 相应类
 * @param methodSel 要被替换的方法名
 * @param methodSelImplementation 替换的方法名
 * @note 如果被替换的方法不存在就执行class_addMethod,如果存在则执行class_replaceMethod且types就忽略掉。
 */
+ (BOOL)replaceMethod:(Class)class method:(SEL)methodSel method:(SEL)methodSelImplementation
{
    Method method = class_getInstanceMethod(class, methodSelImplementation);
    IMP methodImp = method_getImplementation(method);
    const char *type = method_getTypeEncoding(method);
    IMP imp = class_replaceMethod(class, methodSel, methodImp, type);
    
    BOOL result = NO;
    if(imp)
    {
        result = YES;
    }
    return result;
}

/**
 * 添加成员变量
 * @note 不能给已经存在的类添加变量，只能添加一个类并给其添加变量
 */
+ (Class)addIvarClassName:(NSString *)className ivarName:(NSString *)iVarName
{
    Class myClass = objc_allocateClassPair([NSObject class], className.UTF8String, 0);
    BOOL result = class_addIvar(myClass, iVarName.UTF8String, sizeof(NSInteger), 0, "l");
    if(result)
    {
        objc_registerClassPair(myClass);
        return myClass;
    }
    else
    {
        return nil;
    }
}

/**
 * 给类添加属性
 * 属性，一般包括四个定义，原子性、修饰符、类型、名称，另外还有一些只读等定义（可参考下面链接，也可以自己尝试打印属性查看）
 * http://blog.csdn.net/myzlk/article/details/50815381
 */
+ (BOOL)addProperty:(Class)class typeName:(NSString *)typeName propertyName:(NSString *)propertyName
{
    objc_property_attribute_t type = {"T", [NSString stringWithFormat:@"@\"%@\"",typeName].UTF8String};
    objc_property_attribute_t memory = {"C", ""};
    objc_property_attribute_t atomic = {"N", ""};
    objc_property_attribute_t ivar = {"V", [NSString stringWithFormat:@"_%@",propertyName].UTF8String};
    objc_property_attribute_t att[] = {type, memory, atomic, ivar};
    BOOL result = class_addProperty(class, propertyName.UTF8String, att, 4);
    return result;
}


/**
 * 方法交换
 * @param class 方法交换相应类
 * @param method1 方法1
 * @param method2 方法2
 */
+ (void)methodSwap:(Class)class method1:(SEL)method1 method2:(SEL)method2
{
    Method firstMethod = class_getInstanceMethod(class, method1);
    Method secondMethod = class_getInstanceMethod(class, method2);
    method_exchangeImplementations(firstMethod, secondMethod);
}

@end
