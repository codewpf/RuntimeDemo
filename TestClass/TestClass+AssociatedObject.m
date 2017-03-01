//
//  TestClass+AssociatedObject.m
//  LearnRuntime
//
//  Created by wpf on 2017/2/27.
//  Copyright © 2017年 wpf. All rights reserved.
//

#import "TestClass+AssociatedObject.h"
#import "Runtime.h"

@implementation TestClass (AssociatedObject)

static char kDynamicPropertyKey;

- (NSString *)dynamicProperty
{
    return objc_getAssociatedObject(self, &kDynamicPropertyKey);
}

- (void)setDynamicProperty:(NSString *)dynamicProperty
{
    objc_setAssociatedObject(self, &kDynamicPropertyKey, dynamicProperty, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


@end
