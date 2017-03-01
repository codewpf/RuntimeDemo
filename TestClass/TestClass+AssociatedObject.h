//
//  TestClass+AssociatedObject.h
//  LearnRuntime
//
//  Created by wpf on 2017/2/27.
//  Copyright © 2017年 wpf. All rights reserved.
//

#import "TestClass.h"

@interface TestClass (AssociatedObject)

- (NSString *)dynamicProperty;

- (void)setDynamicProperty:(NSString *)dynamicProperty;

@end
